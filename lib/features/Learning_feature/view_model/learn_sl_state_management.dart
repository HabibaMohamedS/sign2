import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/model/models/category_model.dart';


class LearnSlViewModel extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('youtube_playlists').get();

      final fetched = snapshot.docs.map((doc) {
        return CategoryModel.fromJson(
    
          doc.data() ,
        );
      }).toList();

      categories.value = fetched;
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
