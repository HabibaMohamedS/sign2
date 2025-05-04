import cv2
import numpy as np
import mediapipe as mp
# try:
#     import mediapipe as mp
#     print("✅ mediapipe imported successfully")
# except Exception as e:
#     print(f"❌ Error importing mediapipe: {e}")



def extract_keypoints(results):
    # Pose Landmarks (33)
    pose = np.array([[res.x, res.y, res.z] for res in results.pose_landmarks.landmark]) if results.pose_landmarks else np.zeros(33 * 3)
    
    # Face Landmarks (468)
    face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]) if results.face_landmarks else np.zeros(468 * 3)
    
    # Left Hand (21)
    lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]) if results.left_hand_landmarks else np.zeros(21 * 3)
    
    # Right Hand (21)
    rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]) if results.right_hand_landmarks else np.zeros(21 * 3)

    return np.concatenate([pose, face, lh, rh])


mp_holistic = mp.solutions.holistic

# Load and preprocess image
image = cv2.imread('assets/test_image.jpg')  # Replace with the path to your test image
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
print(f"Image shape: {image.shape}")

# Initialize Holistic model
with mp_holistic.Holistic(static_image_mode=True) as holistic:
    results = holistic.process(image)
    
    # Check the results to ensure landmarks are detected
    print("Pose Landmarks:", results.pose_landmarks)
    print("Face Landmarks:", results.face_landmarks)
    print("Left Hand Landmarks:", results.left_hand_landmarks)
    print("Right Hand Landmarks:", results.right_hand_landmarks)

    # Extract keypoints
    keypoints = extract_keypoints(results)
    print("Extracted keypoints:", keypoints)