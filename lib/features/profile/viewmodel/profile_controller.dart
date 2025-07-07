import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final picker = ImagePicker();

  // Observable user info (mock‑data for now)
  Rx<File?> avatarFile   = Rx<File?>(null);
  RxString   username    = ''.obs;
  RxString   address     = ''.obs;
  RxString   phone       = ''.obs;
  Rx<DateTime?> dob      = Rx<DateTime?>(null);

  // Non‑editable field 
  String get email => '';

  /// Pick from camera / gallery
  Future<void> changeAvatar(ImageSource source) async {
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      avatarFile.value = File(picked.path);
      // TODO: upload `avatarFile` to Firebase Storage & update Firestore.
      Get.snackbar('Profile', '95'.tr);
    }
  }

  /// Save editable fields
  void saveChanges() {
    // TODO: push username/address/phone/dob to Firebase user document.
    Get.snackbar('Profile', '96'.tr);
  }

  /// Logout
  void logout() {
    // TODO: FirebaseAuth.instance.signOut();
    //Get.offAllNamed('/login');
  }
}