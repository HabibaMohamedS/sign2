import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';
 

class StorageService {
  static final StorageService _i = StorageService._();
  factory StorageService() => _i;
  StorageService._();

  final _box = GetStorage();

  //On‑boarding flag
  bool get seenOnboarding => false; // //_box.read('seenOnboarding') ?? false;
  set seenOnboarding(bool v) => _box.write('seenOnboarding', v);

  //Auth persistence
 final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  set isLoggedIn(bool v) {
    _isLoggedIn.value = v;          // notify UI listeners
    _box.write('isLoggedIn', v);    // persist to disk
  }

  
  UserModel? get cachedUser {
    final raw = _box.read('user');
    return raw == null
        ? null
        : UserModel.fromJson(Map<String, dynamic>.from(raw));
  }

  set cachedUser(UserModel? u) {
    if (u == null) {
      _box.remove('user');
      isLoggedIn = false;           
    } else {
      _box.write('user', u.toJson());
      isLoggedIn = true;
    }
  }


  void clear() {
    _box.erase();
    _isLoggedIn.value = false;
  }
}