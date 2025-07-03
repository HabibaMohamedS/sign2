import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_dictionary/features/Recommendation%20System/model/learning_center_model.dart';

class FirebaseOperations {
  Future<List<LearningCenter>> fetchLearningCenters() async {
    List<LearningCenter> centers;
    final snapshot =
        await FirebaseFirestore.instance.collection('learning_centers').get();
    centers = snapshot.docs.map((doc) {
      return LearningCenter.fromJson(doc.data());
    }).toList();
    return centers;
  }

  Future<List<LearningCenter>> searchCentersByName(String nameQuery) async {
    try {
      if (nameQuery.isEmpty) {
        return [];
      }
      final querySnapshot = await FirebaseFirestore.instance
          .collection("learning_centers")
          .where('nameLowerCase',
              isGreaterThanOrEqualTo: nameQuery.toLowerCase())
          .where('nameLowerCase',
              isLessThanOrEqualTo: '${nameQuery.toLowerCase()}\uf8ff')
          .limit(20)
          .get();
      print(querySnapshot.docs.length);
      return querySnapshot.docs
          .map((doc) => LearningCenter.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching centers: $e');
      return [];
    }
  }

  Future<List<LearningCenter>> sortCenters(String value) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('learning_centers').get();
    List<LearningCenter> centers = snapshot.docs.map((doc) {
      return LearningCenter.fromJson(doc.data());
    }).toList();

    if (value == "Highest Price") {
      centers.sort((a, b) => (b.price).compareTo(a.price));
      print(centers[0].price);
      return centers;
    } else if (value == "Lowest Price") {
      centers.sort((a, b) => a.price.compareTo(b.price));
      print(centers[0].price);

      return centers;
    } else if (value == "Rating") {
      centers.sort((a, b) => b.rating.compareTo(a.rating));
      print(centers[0].rating);

      return centers;
    } else {
      return [];
    }
  }
}
