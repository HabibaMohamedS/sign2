import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoListScreen extends StatelessWidget {
  final String playlistId;

  VideoListScreen({required this.playlistId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference videosCollection =
    FirebaseFirestore.instance.collection('youtube_playlists').doc(playlistId).collection('videos');

    return Scaffold(
      appBar: AppBar(title: Text('Playlist Videos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: videosCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No videos found."));
          }

          var videos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index];
              return ListTile(
                leading: Image.network(video['thumbnail']),
                title: Text(video['title']),
                onTap: () async {
                  final url = 'https://www.youtube.com/watch?v=${video['videoId']}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
