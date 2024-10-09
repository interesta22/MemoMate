import 'package:shared_preferences/shared_preferences.dart';

class SharedprefHelper {
  // Check if the user has seen the onboarding screen
  Future<bool> checkOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen') ?? false;
  }

  // Set the onboarding screen as seen
  Future<void> setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_seen', true);
  }

  // Check if the user is logged in
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Set the login status
  Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }
}
