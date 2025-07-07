import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();
  
//_box.read('seenOnboarding') ??
  bool get seenOnboarding =>  false;
  set seenOnboarding(bool v) => _box.write('seenOnboarding', v);
}
