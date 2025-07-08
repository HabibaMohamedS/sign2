import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sign2/features/Learning_feature/model/data_sources/data_source.dart';
import 'package:sign2/features/Learning_feature/model/models/lesson_model.dart';

class FirebaseDataSource implements DataSource {
  @override
  Future<List<String>> fetchCategories() {
    throw UnimplementedError();
  }

  @override
  Future<List<LessonModel>> fetchLessons(String playlistId) async {
    try {
      final videosCollection = FirebaseFirestore.instance
          .collection('youtube_playlists')
          .doc(playlistId)
          .collection('videos');

      final snapshot = await videosCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LessonModel.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {

      // Handle Firestore-specific errors
      log('Firestore error: ${e.message}');
      if (e.code == 'permission-denied') {
        log('You do not have permission to access this data.');

      } else if (e.code == 'unavailable') {
        log('Firestore service is currently unavailable.');
      }
      throw e; // Return empty list or rethrow
    } catch (e, stackTrace) {

      // Handle other unexpected errors
      debugPrint('Unexpected error: $e');
      debugPrintStack(stackTrace: stackTrace);
      throw e; // Or rethrow
    }
  }

  Future<List<LessonModel>> fetchQuizLessons(String playlistId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('youtube_playlists')
              .doc(playlistId)
              .collection('videos')
              .get();

      final allLessons =
          snapshot.docs.map((doc) => LessonModel.fromJson(doc.data())).toList();

      allLessons.shuffle(); // Randomize 10 lessons to be taken for ques
      return allLessons.length > 10 ? allLessons.take(10).toList() : allLessons;

    } on FirebaseException catch (e) {

      // Handle Firestore-specific errors
      log('Firestore error: ${e.message}');
      if (e.code == 'permission-denied') {

        log('You do not have permission to access this data.');
      } else if (e.code == 'unavailable') {
        log('Firestore service is currently unavailable.');
      }
      throw e; // Return empty list or rethrow
    } catch (e, stackTrace) {

      // Handle other unexpected errors
      debugPrint('Unexpected error: $e');
      debugPrintStack(stackTrace: stackTrace);
      throw e;

    } // Or rethrow
  }
}
