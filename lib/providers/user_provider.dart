import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_pixels/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  AppUser? _user;
  AppUser? get user => _user;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance(); // ✅ fetch here
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final gender = prefs.getString('gender');

    if (email != null) {
      _user = AppUser(
        name: name ?? '',
        email: email,
        gender: gender ?? 'Male',
        password: '',
      );
      notifyListeners();
    }
  }

  Future<void> loginUser(AppUser user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance(); // ✅ fetch here
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('gender', user.gender);
    // Store password securely
    await _storage.write(key: 'password', value: user.password);
    notifyListeners();
  }
}
