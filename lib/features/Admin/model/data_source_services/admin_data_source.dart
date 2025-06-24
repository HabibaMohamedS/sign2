import 'package:sign2/features/Admin/model/data_source_services/admin_firebase_impl.dart';

abstract class AdminDataSource {
  Future<SignInResult> signIn(String adminId, String password);
}