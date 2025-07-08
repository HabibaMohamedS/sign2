import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class YouTubeScraper {
  final String apiKey;
  final String channelId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  YouTubeScraper({required this.apiKey, required this.channelId});

  /// Fetches all playlists from a YouTube channel and stores them in Firestore.
  Future<void> fetchAndStorePlaylists() async {
    String nextPageToken = '';

    do {
      final String url =
          'https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=$channelId&maxResults=50&pageToken=$nextPageToken&key=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List playlists = data['items'];

          for (var playlist in playlists) {
            final playlistId = playlist['id'];
            final title = playlist['snippet']['title'];
            final thumbnail = playlist['snippet']['thumbnails']['high']['url'];

            // Store playlist in Firestore
            await firestore.collection('youtube_playlists').doc(playlistId).set({
              'playlistId': playlistId,
              'title': title,
              'thumbnail': thumbnail,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Fetch and store videos for this playlist
            await fetchAndStoreVideos(playlistId);
          }

          print("Batch of playlists stored successfully!");

          nextPageToken = data['nextPageToken'] ?? '';
        } else {
          print("Failed to fetch playlists: ${response.statusCode}");
          return;
        }
      } catch (e) {
        print("Error fetching playlists: $e");
        return;
      }
    } while (nextPageToken.isNotEmpty); // Keep fetching if there's a nextPageToken

    print("All playlists have been fetched and stored!");
  }

  /// Fetches all videos from a playlist and stores them in Firestore.
  Future<void> fetchAndStoreVideos(String playlistId) async {
    String nextPageToken = '';

    do {
      final String url =
          'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&maxResults=50&pageToken=$nextPageToken&key=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List videos = data['items'];

          for (var video in videos) {
            final videoId = video['snippet']['resourceId']['videoId'];
            final title = video['snippet']['title'];
            final thumbnail = video['snippet']['thumbnails']['high']['url'];

            await firestore
                .collection('youtube_playlists')
                .doc(playlistId)
                .collection('videos')
                .doc(videoId)
                .set({
              'videoId': videoId,
              'title': title,
              'thumbnail': thumbnail,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }

          print("Batch of videos for Playlist [$playlistId] stored successfully!");

          nextPageToken = data['nextPageToken'] ?? '';
        } else {
          print("Failed to fetch videos: ${response.statusCode}");
          return;
        }
      } catch (e) {
        print("Error fetching videos: $e");
        return;
      }
    } while (nextPageToken.isNotEmpty); // Keep fetching if there's a nextPageToken

    print("All videos for Playlist [$playlistId] have been stored!");
  }
}
