import 'package:get/get.dart';
import 'package:sign2/features/Learning_feature/model/data_sources/firebase_data_source.dart';
import 'package:sign2/features/Learning_feature/model/models/lesson_model.dart';

class LessonsStateManagement extends GetxController {
 
  var lessons = <LessonModel>[].obs;
  var isLoading = true.obs;
  var lessonIndex = 0.obs;

  void updateLessonIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < lessons.length) {
      lessonIndex.value = newIndex;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchLessonData(String playlistId) async {
    try {
      isLoading.value = true;
      FirebaseDataSource dataSource = FirebaseDataSource();
      final fetchedLessons = await dataSource.fetchLessons(playlistId);
      lessons.assignAll(fetchedLessons);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch lessons: $e');
    }
  }

  // void updateLessonIndex(int index) {
  //   if (index >= 0 && index < lessons.length) {
  //     lessonIndex.value = index;
  //   }
//  }
}