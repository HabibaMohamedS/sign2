import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:sign2/features/Auth/model/UserModel.dart';

class FirebaseAuthentication {
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
      });
      return "success";
    } on fb_auth.FirebaseAuthException catch (e) {
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
}
