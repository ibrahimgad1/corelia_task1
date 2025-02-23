import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<Map<String, dynamic>> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? "ibrahim gad",
      'bio': prefs.getString('bio') ?? "Flutter Developer",
      'profilePic': prefs.getString('profilePic'),
      'textColor': prefs.getInt('textColor'),
    };
  }

  static Future<void> updateProfile(String name, String bio, String? profilePic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('bio', bio);
    if (profilePic != null) {
      await prefs.setString('profilePic', profilePic);
    }
  }

  static Future<void> updateTextColor(int colorValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('textColor', colorValue);
  }
}
