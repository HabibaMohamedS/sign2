import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign2/features/Recommendation%20System/model/learning_center_model.dart';

class FirebaseOperations {
  Future<List<LearningCenter>> fetchLearningCenters() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('learning_centers').get();

    return snapshot.docs.map((doc) {
      return LearningCenter.fromJson(doc.data());
    }).toList();
  }
}
