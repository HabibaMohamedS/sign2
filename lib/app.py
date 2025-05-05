import sys
print(sys.version)

print("⏳ Starting app.py...")

# Try importing required libraries
try:
    import cv2
    print("✅ cv2 imported successfully")
except Exception as e:
    print(f"❌ Error importing cv2: {e}")

try:
    import os
    print("✅ os imported successfully")
except Exception as e:
    print(f"❌ Error importing os: {e}")

try:
    import tempfile
    print("✅ tempfile imported successfully")
except Exception as e:
    print(f"❌ Error importing tempfile: {e}")

try:
    import tensorflow as tf
    print("✅ tf imported successfully")
except Exception as e:
    print(f"❌ Error importing tf: {e}")

try:
    import mediapipe as mp
    print("✅ mediapipe imported successfully")
except Exception as e:
    print(f"❌ Error importing mediapipe: {e}")

try:
    import numpy as np
    print("✅ numpy imported successfully")
except Exception as e:
    print(f"❌ Error importing numpy: {e}")

try:
    from flask import Flask, request, jsonify
    print("✅ flask imported successfully")
except Exception as e:
    print(f"❌ Error importing flask: {e}")

print("⏳ Starting app.py...")

# Load the Keras model
model_path = os.path.join(os.path.dirname(__file__), 'models', '100model.h5')
print(f"🔄 Loading model from {model_path}...")
model = tf.keras.models.load_model(model_path)
model.compile(optimizer='Adam', loss='categorical_crossentropy', metrics=['accuracy'])
print("✅ Model loaded.")

# Define your classes and parameters
actions = [
    'baby','eat','father','finish','good','happy','hear','house','important',
    'love','mall','me','mosque','mother','normal','sad','stop','thanks',
    'thinking','worry'
]
threshold = 0.85
window_size = 30
motion_threshold = 0.3

# Initialize MediaPipe Holistic
mp_holistic = mp.solutions.holistic
print("✅ MediaPipe Holistic ready.")

app = Flask(__name__)

def extract_keypoints(results):
    pose = (np.array([[res.x, res.y, res.z, res.visibility] 
              for res in results.pose_landmarks.landmark]).flatten()
            if results.pose_landmarks else np.zeros(33*4))
    face = (np.array([[res.x, res.y, res.z] 
              for res in results.face_landmarks.landmark]).flatten()
            if results.face_landmarks else np.zeros(468*3))
    lh = (np.array([[res.x, res.y, res.z] 
             for res in results.left_hand_landmarks.landmark]).flatten()
          if results.left_hand_landmarks else np.zeros(21*3))
    rh = (np.array([[res.x, res.y, res.z] 
             for res in results.right_hand_landmarks.landmark]).flatten()
          if results.right_hand_landmarks else np.zeros(21*3))
    return np.concatenate([pose, face, lh, rh])

def motion_filter(seq):
    if len(seq) < 2:
        return False
    diff = np.diff(seq[-2:], axis=0)
    hand_motion = np.linalg.norm(diff[:, :42], axis=1).mean()
    body_motion = np.linalg.norm(diff[:, 42:42+132], axis=1).mean()
    face_motion = np.linalg.norm(diff[:, 42+132:], axis=1).mean()
    weighted = 0.8*hand_motion + 0.15*body_motion + 0.05*face_motion
    print(f"🔍 Motion filter: hand={hand_motion:.4f}, body={body_motion:.4f}, face={face_motion:.4f}, weighted={weighted:.4f}")
    return weighted > motion_threshold

@app.route('/translate_video', methods=['POST'])
def translate_video():
    print("📥 /translate_video called")
    file = request.files.get('video')
    if not file:
        print("❌ No video file received")
        return "No video provided", 400

    # Save to temp (Windows‑safe)
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    tmp_path = tmp.name
    tmp.close()                    # <-- release Python lock on file
    file.save(tmp_path)
    print(f"💾 Saved uploaded video to {tmp_path}")

    # Extract frames
    cap = cv2.VideoCapture(tmp_path)
    frames = []
    idx = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
        idx += 1
    cap.release()                 # <-- release OpenCV lock
    print(f"🎞️ Extracted {len(frames)} frames")

    # Delete temp file now that it's closed
    try:
        os.unlink(tmp_path)
        print(f"🗑️ Deleted temp file {tmp_path}")
    except Exception as e:
        print(f"⚠️ Could not delete temp file: {e}")

    # Process frames in Mediapipe + model
    seq = []
    sentence = []
    with mp_holistic.Holistic(
        static_image_mode=True,
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5
    ) as holistic:
        for i, frame in enumerate(frames):
            print(f"🔄 Frame {i+1}/{len(frames)} processing")
            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            results = holistic.process(rgb)
            kp = extract_keypoints(results)

            seq.append(kp)
            if len(seq) > window_size:
                seq.pop(0)

            if len(seq) == window_size and motion_filter(seq):
                input_data = np.expand_dims(seq, axis=0)
                res_probs = model.predict(input_data)[0]
                print(f"🤖 Model probs: {res_probs}")

                if np.max(res_probs) > threshold:
                    action = actions[np.argmax(res_probs)]
                    if not sentence or action != sentence[-1]:
                        sentence.append(action)
                        print(f"✅ Detected action: {action}")

                if len(sentence) > 5:
                    sentence = sentence[-5:]

    final_sentence = ' '.join(sentence) if sentence else '---'
    print(f"🏁 Final sentence: {final_sentence}")
    return final_sentence, 200

if __name__ == '__main__':
    print("🚀 Starting Flask server on port 5000")
    app.run(host='0.0.0.0', port=5000, debug=True)