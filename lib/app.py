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

# Initialize Flask app and mediapipe
app = Flask(__name__)
mp_holistic = mp.solutions.holistic

print("✅ Flask app and mp_holistic initialized")

# def extract_keypoints(results):
#     # Pose Landmarks (33)
#     pose = np.array([[res.x, res.y, res.z] for res in results.pose_landmarks.landmark]).flatten() if results.pose_landmarks else np.zeros(33 * 3)
    
#     # Face Landmarks (468)
#     face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]).flatten() if results.face_landmarks else np.zeros(468 * 3)
    
#     # Left Hand (21)
#     lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21 * 3)
    
#     # Right Hand (21)
#     rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21 * 3)

#     return np.concatenate([pose, face, lh, rh])

def extract_keypoints(results):
    # Pose Landmarks (33)
    try:
        pose = np.array([[res.x, res.y, res.z] for res in results.pose_landmarks.landmark]).flatten() if results.pose_landmarks else np.zeros(33 * 3)
    except Exception as e:
        print("Error extracting pose landmarks:", e)
        pose = np.zeros(33 * 3)

    # Face Landmarks (468)
    try:
        face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]).flatten() if results.face_landmarks else np.zeros(468 * 3)
    except Exception as e:
        print("Error extracting face landmarks:", e)
        face = np.zeros(468 * 3)

    # Left Hand (21)
    try:
        lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21 * 3)
    except Exception as e:
        print("Error extracting left hand landmarks:", e)
        lh = np.zeros(21 * 3)

    # Right Hand (21)
    try:
        rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21 * 3)
    except Exception as e:
        print("Error extracting right hand landmarks:", e)
        rh = np.zeros(21 * 3)

    return np.concatenate([pose, face, lh, rh])

## //curl -X POST http://127.0.0.1:5000/process ^
##//     -F "D:\GraduationProject\flutter\sign2\assets\test_image.jpg"

@app.route('/process', methods=['POST'])
def process():
    print("Received image from client." ,flush=True)
    file = request.files['image']
    image = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    # Process the image using mediapipe Holistic
    with mp_holistic.Holistic(static_image_mode=True) as holistic:
        results = holistic.process(image)
        print("Results from holistic process:", results)
        if results.pose_landmarks:
            print("Pose landmarks:", results.pose_landmarks)
        if results.face_landmarks:
            print("Face landmarks:", results.face_landmarks)
        if results.left_hand_landmarks:
            print("Left hand landmarks:", results.left_hand_landmarks)
        if results.right_hand_landmarks:
            print("Right hand landmarks:", results.right_hand_landmarks)
        keypoints = extract_keypoints(results)

    
    print("Extracted keypoints:", keypoints.shape, keypoints[:5])  # preview first few values
    return jsonify({'keypoints': keypoints.tolist()})

# Start the Flask app
if __name__ == '__main__':
    print("🚀 Starting Flask server...")
    app.run(host='0.0.0.0', port=5000, debug=True)
