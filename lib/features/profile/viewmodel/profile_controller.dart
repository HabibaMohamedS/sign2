import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign2/features/Auth/Controller/firebase_auth.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';
import 'package:sign2/features/menu/main_menu_screen.dart';
import 'package:sign2/services/storage_services.dart';

class ProfileController extends GetxController {
  ProfileController(this._user);

  final UserModel _user;
  // Services
  final picker = ImagePicker();
  final _cache = StorageService();
  final _firestore = FirebaseFirestore.instance;
  final _authService = FirebaseAuthentication();

  //Reactive user fields
  Rx<File?> avatarFile = Rx<File?>(null);
  late RxString username    = _user.username.obs;
  late RxString address     = _user.address.obs;
  late RxString phone       = _user.phoneNumber.obs;
  late RxString government  = _user.government.obs;

  String get email     => _user.email;

  //Save
  Future<void> saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    await _firestore.collection('users').doc(uid).update({
      'username'  : username.value,
      'address'   : address.value,
      'phone'     : phone.value,
      'government': government.value,
    });

    _cache.cachedUser = _cache.cachedUser!.copyWith(
      username   : username.value,
      address    : address.value,
      phoneNumber: phone.value,
      government : government.value,
    );

    Get.snackbar('Profile', 'Changes saved successfully');
  }

  //Logout 
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(MainMenuScreen.routeName);
  }
}