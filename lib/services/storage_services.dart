import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';

class StorageService {
  static final StorageService _i = StorageService._();
  factory StorageService() => _i;
  StorageService._() {
    final raw = _box.read('user');
    if (raw != null) {
      _userRx.value = UserModel.fromJson(Map<String, dynamic>.from(raw));
    }
  }

  final _box = GetStorage();

  
  final Rxn<UserModel> _userRx = Rxn<UserModel>();

  UserModel? get cachedUser => _userRx.value;
  bool get isLoggedIn => _userRx.value != null;

  set cachedUser(UserModel? user) {
    _userRx.value = user;
    if (user == null) {
      _box.remove('user');
    } else {
      _box.write('user', user.toJson());
    }
  }

  //On‑boarding flag
  bool get seenOnboarding => false; // //_box.read('seenOnboarding') ?? false;
  set seenOnboarding(bool v) => _box.write('seenOnboarding', v);

  void clear() => cachedUser = null;
}
