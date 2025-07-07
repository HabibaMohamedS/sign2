import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign2/features/Auth/Controller/firebase_auth.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';
import 'package:sign2/services/storage_services.dart';

class ProfileController extends GetxController {
  ProfileController(this._user);

  final UserModel _user;
  final picker = ImagePicker();
  final _cache = StorageService();
  final _authService = FirebaseAuthentication();
  final _firestore = FirebaseFirestore.instance;

  Rx<File?> avatarFile = Rx<File?>(null);
  late RxString username = _user.username.obs;
  late RxString address  = _user.address.obs;
  late RxString phone    = _user.phoneNumber.obs;
  Rx<DateTime?> dob      = Rx<DateTime?>(null);

  String get email => _user.email;
  String? get imageUrl => _user.imageUrl;

  // ---------- Avatar ----------
  Future<void> changeAvatar(ImageSource source) async {
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    avatarFile.value = File(picked.path);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('avatars/$uid.jpg');

    await ref.putFile(avatarFile.value!);
    final url = await ref.getDownloadURL();

    await _firestore.collection('users').doc(uid).update({'imageUrl': url});

    // update cache
    _cache.cachedUser = _cache.cachedUser!.copyWith(imageUrl: url);
    Get.snackbar('Profile', 'Photo updated successfully');
  }

  // ---------- Save text fields ----------
  Future<void> saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'username': username.value,
      'address': address.value,
      'phone': phone.value,
      'dob': dob.value?.toIso8601String(),
    });

    _cache.cachedUser =
        _cache.cachedUser!.copyWith(username: username.value, address: address.value, phoneNumber: phone.value);

    Get.snackbar('Profile', 'Changes saved successfully');
  }

  // ---------- Logout ----------
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}




// class ProfileController extends GetxController {
//   final picker = ImagePicker();

//   Rx<File?> avatarFile   = Rx<File?>(null);
//   RxString   username    = ''.obs;
//   RxString   address     = ''.obs;
//   RxString   phone       = ''.obs;
//   Rx<DateTime?> dob      = Rx<DateTime?>(null);

//   // Non‑editable field 
//   String get email => '';

//   Future<void> changeAvatar(ImageSource source) async {
//     final picked = await picker.pickImage(source: source, imageQuality: 85);
//     if (picked != null) {
//       avatarFile.value = File(picked.path);
//       // TODO: upload `avatarFile` to Firebase Storage & update Firestore.
//       Get.snackbar('Profile', 'Photo updated successfully');
//     }
//   }


//   void saveChanges() {
//     // TODO: push username/address/phone/dob to Firebase user document.
//     Get.snackbar('Profile', 'Changes saved successfully');
//   }

//   /// Logout
//   void logout() {
//     // TODO: FirebaseAuth.instance.signOut();
//     //Get.offAllNamed('/login');
//   }
// }