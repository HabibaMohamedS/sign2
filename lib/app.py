import cv2
import mediapipe as mp
import numpy as np
from flask import Flask, request, jsonify

app = Flask(__name__)
mp_holistic = mp.solutions.holistic

def extract_keypoints(results):
    # Pose Landmarks (33)
    pose = np.array([[res.x, res.y, res.z] for res in results.pose_landmarks.landmark]).flatten() if results.pose_landmarks else np.zeros(33 * 3)
    
    # Face Landmarks (468)
    face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]).flatten() if results.face_landmarks else np.zeros(468 * 3)
    
    # Left Hand (21)
    lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21 * 3)
    
    # Right Hand (21)
    rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21 * 3)

    return np.concatenate([pose, face, lh, rh])

@app.route('/process', methods=['POST'])
def process():
    file = request.files['image']
    image = cv2.imdecode(np.frombuffer(file.read(), np.uint8), cv2.IMREAD_COLOR)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    with mp_holistic.Holistic(static_image_mode=True) as holistic:
        results = holistic.process(image)
        keypoints = extract_keypoints(results)
    
    return jsonify({'keypoints': keypoints.tolist()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
