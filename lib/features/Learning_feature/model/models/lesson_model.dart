import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  String? videoId;
  String? title;
  String? thumbnail;
  DateTime? timestamp;

  LessonModel({
    this.videoId,
    this.title,
    this.thumbnail,
    this.timestamp,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {

    String? rawTitle = json['title'];
    final match = RegExp(r'["“”](.*?)["“”]').firstMatch(rawTitle ?? '');
    final cleanedTitle = match != null ? match.group(1)?.trim() : rawTitle?.trim();

    return LessonModel(
      videoId: json['videoId'],
      title: cleanedTitle,
      thumbnail: json['thumbnail'],
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
    );
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoId'] = videoId;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['timestamp'] = timestamp;
    return data;
  }
}