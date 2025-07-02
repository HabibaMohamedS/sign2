import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_list_screen.dart';

class PlaylistScreen extends StatelessWidget {
  final CollectionReference playlistsCollection =
  FirebaseFirestore.instance.collection('youtube_playlists');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Playlists')),
      body: StreamBuilder<QuerySnapshot>(
        stream: playlistsCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No playlists found."));
          }

          var playlists = snapshot.data!.docs;

          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              var playlist = playlists[index];
              return ListTile(
                leading: Image.network(playlist['thumbnail']),
                title: Text(playlist['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoListScreen(playlistId: playlist.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
