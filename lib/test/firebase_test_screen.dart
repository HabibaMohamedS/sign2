import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String message = "Testing Firebase...";

  @override
  void initState() {
    super.initState();
    testFirebaseConnection();
  }

  Future<void> testFirebaseConnection() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('youtube_playlists')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          message = "✅ Firebase connected! Data found in youtube_playlists.";
        });
      } else {
        setState(() {
          message = "✅ Firebase connected! But youtube_playlists is empty.";
        });
      }
    } catch (e) {
      setState(() {
        message = "❌ Firebase failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
