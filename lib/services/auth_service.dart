import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _sessionKey = 'auth_session';
  static const String _usersKey = 'registered_users';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get current logged-in user details
  static Map<String, dynamic>? getCurrentSession() {
    final sessionStr = _prefs?.getString(_sessionKey);
    if (sessionStr == null) return null;
    try {
      return json.decode(sessionStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Set current user session
  static Future<void> _setSession(Map<String, dynamic> user) async {
    await _prefs?.setString(_sessionKey, json.encode(user));
  }

  // Check if logged in
  static bool isLoggedIn() {
    return _prefs?.containsKey(_sessionKey) ?? false;
  }

  // Sign up a user
  static Future<bool> signUp(String name, String email, String password) async {
    final users = _getRegisteredUsers();
    if (users.containsKey(email)) {
      return false; // User already exists
    }
    
    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password,
      'authProvider': 'email',
    };
    
    users[email] = newUser;
    await _saveRegisteredUsers(users);
    
    // Auto log in after signup
    await _setSession({
      'id': newUser['id'],
      'name': newUser['name'],
      'email': newUser['email'],
      'authProvider': 'email',
    });
    return true;
  }

  // Log in a user
  static Future<bool> logIn(String email, String password) async {
    final users = _getRegisteredUsers();
    final user = users[email];
    if (user != null && user['password'] == password) {
      await _setSession({
        'id': user['id'],
        'name': user['name'],
        'email': user['email'],
        'authProvider': user['authProvider'],
      });
      return true;
    }
    return false;
  }

  // Mock Google Sign-In
  static Future<bool> signInWithGoogle(String mockName, String mockEmail) async {
    final users = _getRegisteredUsers();
    
    Map<String, dynamic>? user = users[mockEmail];
    if (user == null) {
      // Create new account
      user = {
        'id': 'g_${DateTime.now().millisecondsSinceEpoch}',
        'name': mockName,
        'email': mockEmail,
        'authProvider': 'google',
      };
      users[mockEmail] = user;
      await _saveRegisteredUsers(users);
    }

    await _setSession({
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'authProvider': 'google',
    });
    return true;
  }

  // Mock Apple Sign-In
  static Future<bool> signInWithApple(String mockName, String mockEmail) async {
    final users = _getRegisteredUsers();
    
    Map<String, dynamic>? user = users[mockEmail];
    if (user == null) {
      // Create new account
      user = {
        'id': 'a_${DateTime.now().millisecondsSinceEpoch}',
        'name': mockName,
        'email': mockEmail,
        'authProvider': 'apple',
      };
      users[mockEmail] = user;
      await _saveRegisteredUsers(users);
    }

    await _setSession({
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'authProvider': 'apple',
    });
    return true;
  }

  // Log out
  static Future<void> logOut() async {
    await _prefs?.remove(_sessionKey);
  }

  // Helper: Get all registered users
  static Map<String, dynamic> _getRegisteredUsers() {
    final usersStr = _prefs?.getString(_usersKey);
    if (usersStr == null) return {};
    try {
      return json.decode(usersStr) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  // Helper: Save all registered users
  static Future<void> _saveRegisteredUsers(Map<String, dynamic> users) async {
    await _prefs?.setString(_usersKey, json.encode(users));
  }
}
