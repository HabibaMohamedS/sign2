import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign2/features/Admin/model/data_source_services/admin_data_source.dart';


class AdminFirebaseImpl extends AdminDataSource {
  @override
  Future<SignInResult> signIn(String adminId, String password) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Admin').get();

      for (var doc in snapshot.docs) {
        if (doc['id'] == adminId && doc['password'] == password) {
          log('Sign in successful');
          return SignInResult(success: true);
        }
        if (doc['id'] == adminId && doc['password'] != password) {
          log('Incorrect password');
          return SignInResult(
              success: false, errorMessage: 'Incorrect password');
        }
        
      }
      return SignInResult(success: false, errorMessage: 'Invalid admin ID ');
    } catch (e) {
      log('Error fetching documents: $e');
      return SignInResult(success: false, errorMessage: e.toString());
    }
  }
}

//Temporary class to handle the result of the sign-in process
// This should be replaced with a more robust error handling mechanism
class SignInResult {
  final bool success;
  final String? errorMessage;

  SignInResult({required this.success, this.errorMessage});
}
