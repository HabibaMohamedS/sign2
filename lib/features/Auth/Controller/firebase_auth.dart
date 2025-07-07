import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';
import 'package:sign2/services/storage_services.dart';
import 'package:sign2/support/theme/app_images.dart';

class FirebaseAuthentication {
  final _auth = FirebaseAuth.instance;
  final _storage = StorageService();

  Future<String> register(UserModel user) async {
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      String uid = credentials.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "username": user.username,
        "email": user.email,
        "password": user.password,
        "government": user.government,
        "address": user.address,
        "phone": user.phoneNumber,
        "imageUrl": null,
      });

      // persist
      _storage
        ..isLoggedIn = true
        ..cachedUser = user.copyWith(imageUrl: null);

      return "success";
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        return 'The password is too weak.';
      } else {
        return 'Registration failed: ${e.message}';
      }
    } catch (e) {
      return 'Something went wrong: $e';
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final userId = userCredential.user?.uid;
      if (userId == null) throw Exception('User ID is null');

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }
      final userData = userDoc.data() as Map<String, dynamic>;
      final userModel = UserModel(
        username: userData['username'],
        email: userData['email'],
        password: "",
        government: userData['government'] ?? "",
        address: userData['address'] ?? "",
        phoneNumber: userData['phone'] ?? "",
        imageUrl: userData['imageUrl'] ?? AppImages.defaultAvatar,
      );

      //print("#########${userDoc['username']}");

      _storage
        ..isLoggedIn = true
        ..cachedUser = userModel;
    } catch (e) {
      //print('Login Exception: $e');
      return null;
    }
  }

   /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    _storage.clear();
  }
}
