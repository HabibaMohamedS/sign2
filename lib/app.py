
# import os
# import cv2
# import tempfile
# import numpy as np
# from fastapi import FastAPI, File, UploadFile, HTTPException
# from starlette.responses import PlainTextResponse
# import mediapipe as mp
# import tensorflow as tf
# # import uvicorn


# # 1. Load Keras model once
# MODEL_PATH =os.path.join(os.path.dirname(__file__), 'models', '100model.h5') 
# # model = tf.keras.models.load_model(MODEL_PATH)
# # model.compile(optimizer='Adam', loss='categorical_crossentropy', metrics=['accuracy'])

# # 2. Classes & parameters
# ACTIONS = [
#     'baby','eat','father','finish','good','happy','hear','house','important',
#     'love','mall','me','mosque','mother','normal','sad','stop','thanks',
#     'thinking','worry'
# ]
# THRESHOLD = 0.85
# WINDOW_SIZE = 30
# MOTION_THRESHOLD = 0.3
# FRAME_SIZE = (320, 240)

# # 3. Long‑lived MediaPipe Holistic in streaming mode
# mp_holistic = mp.solutions.holistic
# holistic = mp_holistic.Holistic(
#     static_image_mode=False,
#     model_complexity=1,
#     min_detection_confidence=0.5,
#     min_tracking_confidence=0.5
# )
# print("MediaPipe Holistic initialized.")

# # 4. FastAPI setup
# app = FastAPI(title="SignLang Translator API")

# def extract_keypoints(results):
#     pose = (np.array([[res.x, res.y, res.z, res.visibility]
#              for res in results.pose_landmarks.landmark]).flatten()
#             if results.pose_landmarks else np.zeros(33*4))
#     face = (np.array([[res.x, res.y, res.z]
#              for res in results.face_landmarks.landmark]).flatten()
#             if results.face_landmarks else np.zeros(468*3))
#     lh = (np.array([[res.x, res.y, res.z]
#            for res in results.left_hand_landmarks.landmark]).flatten()
#           if results.left_hand_landmarks else np.zeros(21*3))
#     rh = (np.array([[res.x, res.y, res.z]
#            for res in results.right_hand_landmarks.landmark]).flatten()
#           if results.right_hand_landmarks else np.zeros(21*3))
#     return np.concatenate([pose, face, lh, rh])

# def motion_filter(seq):
#     if len(seq) < 2:
#         return False
#     diff = np.diff(seq[-2:], axis=0)
#     hand_motion = np.linalg.norm(diff[:, :42], axis=1).mean()
#     body_motion = np.linalg.norm(diff[:, 42:42+132], axis=1).mean()
#     face_motion = np.linalg.norm(diff[:, 42+132:], axis=1).mean()
#     weighted = 0.8*hand_motion + 0.15*body_motion + 0.05*face_motion
#     return weighted > MOTION_THRESHOLD

# @app.post("/translate_video", response_class=PlainTextResponse)
# async def translate_video(video: UploadFile = File(...)):
#     print("/translate_video called")
#     # Save upload to temp file, then close to release lock
#     tmp = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
#     tmp_path = tmp.name
#     tmp.close()
#     with open(tmp_path, 'wb') as f:
#         f.write(await video.read())
#     print(f"Video saved to {tmp_path}")

#     # Extract & downscale frames
#     cap = cv2.VideoCapture(tmp_path)
#     frames = []
#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             break
#         frames.append(cv2.resize(frame, FRAME_SIZE))
#     cap.release()
#     try:
#         os.unlink(tmp_path)
#     except:
#         pass
#     print(f"{len(frames)} frames loaded and downscaled")

#     # Build sliding windows of keypoints
#     seq_buffer = []
#     windows = []  # will hold each WINDOW_SIZE sequence
#     for idx, frame in enumerate(frames):
#         rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
#         results = holistic.process(rgb)
#         kp = extract_keypoints(results)
#         seq_buffer.append(kp)
#         if len(seq_buffer) > WINDOW_SIZE:
#             seq_buffer.pop(0)
#         if len(seq_buffer) == WINDOW_SIZE and motion_filter(seq_buffer):
#             windows.append(np.stack(seq_buffer, axis=0))
#     print(f"Built {len(windows)} candidate windows")

#     # If no windows, return empty
#     if not windows:
#         return '---'

#     # Batch predict all windows
#     batch_input = np.stack(windows, axis=0)   # shape: (N, WINDOW_SIZE, features)
#     print(f"Running batch inference on {batch_input.shape[0]} windows...")
#     batch_preds = model.predict(batch_input, verbose=0)  # shape: (N, num_actions)
#     print(f"Raw predictions shape: {batch_preds.shape}")

#     # Assemble sentence from high‑confidence, non‑repeating actions
#     sentence = []
#     for probs in batch_preds:
#         if np.max(probs) > THRESHOLD:
#             action = ACTIONS[np.argmax(probs)]
#             if not sentence or action != sentence[-1]:
#                 sentence.append(action)
#     sentence = sentence[-5:]  # limit length
#     final = ' '.join(sentence) if sentence else '---'
#     print(f"Final sentence: {final}")

#     return final

# if __name__ == "__main__":
#     # Only the main process prints startup info
#     print("Starting SignLang Translator API…")
#     print(f"Loading model from {MODEL_PATH}…")
#     model = tf.keras.models.load_model(MODEL_PATH)
#     model.compile(optimizer='Adam', loss='categorical_crossentropy', metrics=['accuracy'])
#     print("Model loaded. Initializing MediaPipe…")
#     # Note: we already created `holistic` above
#     print("MediaPipe initialized. Launching server…")
#     import uvicorn
#     uvicorn.run("app:app", host="0.0.0.0", port=5000, workers=2)
import os
import cv2
import tempfile
import numpy as np
from fastapi import FastAPI, File, UploadFile, HTTPException
from starlette.responses import PlainTextResponse
import mediapipe as mp
import tensorflow as tf
import uvicorn
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
print("⏳ Starting app.py...")


# Load tokenizer and NLP model
# tokenizer = AutoTokenizer.from_pretrained("akhooli/gpt2-small-arabic")
# NLPmodel = AutoModelForCausalLM.from_pretrained("akhooli/gpt2-small-arabic")

# 1. Load Keras model once
MODEL_PATH = os.path.join(os.path.dirname(__file__), 'models', '100model.h5')
print(f"🔄 Loading model from {MODEL_PATH}...")
model = tf.keras.models.load_model(MODEL_PATH)
model.compile(optimizer='Adam', loss='categorical_crossentropy', metrics=['accuracy'])
print("✅ Model loaded.")

# 2. Classes & parameters
ACTIONS = [
    'baby','eat','father','finish','good','happy','hear','house','important',
    'love','mall','me','mosque','mother','normal','sad','stop','thanks',
    'thinking','worry'
]
ARABIC_ACTIONS = [
    'طفل', 'أكل', 'أب', 'إنهاء', 'جيد', 'سعيد', 'سمع', 'منزل', 'مهم',
    'حب', 'مول', 'أنا', 'مسجد', 'أم', 'عادي', 'حزين', 'توقف', 'شكرا',
    'تفكير', 'قلق'
]
THRESHOLD = 0.90
WINDOW_SIZE = 30
MOTION_THRESHOLD = 0.3
FRAME_SIZE = (320, 240)

# 3. Long‑lived MediaPipe Holistic in streaming mode
mp_holistic = mp.solutions.holistic
holistic = mp_holistic.Holistic(
    static_image_mode=False,
    model_complexity=1,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)
print("✅ MediaPipe Holistic initialized.")

# 4. FastAPI setup
app = FastAPI(title="SignLang Translator API")

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
    return weighted > MOTION_THRESHOLD


def signs_to_arabic_sentence(signs):
    tokenizer = AutoTokenizer.from_pretrained("UBC-NLP/araT5-base")
    model = AutoModelForSeq2SeqLM.from_pretrained("UBC-NLP/araT5-base")

    prompt = " ".join(signs)  
    input_ids = tokenizer(prompt, return_tensors="pt").input_ids

    output_ids = model.generate(
    input_ids,
    max_length=10,
    num_beams=5,
    no_repeat_ngram_size=2,
    early_stopping=True,
    temperature=0.7
    )

    sentence = tokenizer.decode(output_ids[0], skip_special_tokens=True)
    return sentence


@app.post("/translate_video", response_class=PlainTextResponse)
async def translate_video(video: UploadFile = File(...)):
    print("📥 /translate_video called")
    # Save upload to temp file, then close to release lock
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    tmp_path = tmp.name
    tmp.close()
    with open(tmp_path, 'wb') as f:
        f.write(await video.read())
    print(f"💾 Video saved to {tmp_path}")

    # Extract & downscale frames
    cap = cv2.VideoCapture(tmp_path)
    frames = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(cv2.resize(frame, FRAME_SIZE))
    cap.release()
    try:
        os.unlink(tmp_path)
    except:
        pass
    print(f"🎞️ {len(frames)} frames loaded and downscaled")

    # Build sliding windows of keypoints
    seq_buffer = []
    windows = []  # will hold each WINDOW_SIZE sequence
    for idx, frame in enumerate(frames):
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = holistic.process(rgb)
        kp = extract_keypoints(results)
        seq_buffer.append(kp)
        if len(seq_buffer) > WINDOW_SIZE:
            seq_buffer.pop(0)
        if len(seq_buffer) == WINDOW_SIZE and motion_filter(seq_buffer):
            windows.append(np.stack(seq_buffer, axis=0))
    print(f"🔢 Built {len(windows)} candidate windows")

    # If no windows, return empty
    if not windows:
        return '---'

    # Batch predict all windows
    batch_input = np.stack(windows, axis=0)   # shape: (N, WINDOW_SIZE, features)
    print(f"🤖 Running batch inference on {batch_input.shape[0]} windows...")
    batch_preds = model.predict(batch_input, verbose=0)  # shape: (N, num_actions)
    print(f"🧮 Raw predictions shape: {batch_preds.shape}")

    # Assemble sentence from high‑confidence, non‑repeating actions
    sentence = []
    for probs in batch_preds:
        if np.max(probs) > THRESHOLD:
            action = ARABIC_ACTIONS[np.argmax(probs)]
            if not sentence or action != sentence[-1]:
                sentence.append(action)
    sentence = sentence[-5:]  # limit length
    final = ' '.join(sentence) if sentence else '---'
    arabic_sentence = signs_to_arabic_sentence(final.split())
    print(f"🏁 Final sentence: {final}")
    print(f"📝 Translated to Arabic: {arabic_sentence}")
    return arabic_sentence
    # return final

if __name__ == "__main__":
    print("🚀 Launching Uvicorn server on port 5000 ")
    uvicorn.run("app:app", host="0.0.0.0", port=5000)
