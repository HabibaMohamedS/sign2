import 'package:get_storage/get_storage.dart';
import 'package:sign2/features/Auth/model/UserModel.dart';

// class StorageService {
//   final _box = GetStorage();
  
// //_box.read('seenOnboarding') ??
//   bool get seenOnboarding =>  false;
//   set seenOnboarding(bool v) => _box.write('seenOnboarding', v);

class StorageService {
  static final StorageService _i = StorageService._();
  factory StorageService() => _i;
  StorageService._();

  final _box = GetStorage();

  // -------- On‑boarding flag --------
  bool get seenOnboarding => _box.read('seenOnboarding') ?? false;
  set seenOnboarding(bool v) => _box.write('seenOnboarding', v);

  // -------- Auth persistence --------
  bool get isLoggedIn => _box.read('isLoggedIn') ?? false;
  set isLoggedIn(bool v) => _box.write('isLoggedIn', v);

  UserModel? get cachedUser {
    final raw = _box.read('user');
    return raw == null ? null : UserModel.fromJson(Map<String, dynamic>.from(raw));
  }

  set cachedUser(UserModel? u) =>
      u == null ? _box.remove('user') : _box.write('user', u.toJson());

  void clear() => _box.erase();
}