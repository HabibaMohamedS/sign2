import 'package:sign2/features/Learning_feature/model/models/lesson_model.dart';

abstract class DataSource {
  Future<List<String>> fetchCategories();
  Future<List<LessonModel>> fetchLessons(String playlistId);
  //Future<List<String>> fetchLessonsByCategory(String categoryId);
}