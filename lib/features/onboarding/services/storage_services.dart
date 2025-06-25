import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  bool get seenOnboarding => _box.read('seenOnboarding') ?? false;
  set seenOnboarding(bool v) => _box.write('seenOnboarding', v);
}
