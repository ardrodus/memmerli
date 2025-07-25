import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'current_user';
  
  // Mock user data
  static const Map<String, String> _mockUser = {
    'username': 'Test',
    'password': 'Test',
    'email': 'test@example.com',
    'id': '1',
  };
  
  // Mock login function
  static Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check credentials against mock user
    if ((email == _mockUser['email'] || email == _mockUser['username']) && 
        password == _mockUser['password']) {
      // Save user session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode({
        'id': _mockUser['id'],
        'username': _mockUser['username'],
        'email': _mockUser['email'],
      }));
      
      return true;
    }
    
    return false;
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    return userJson != null;
  }
  
  // Get current user info
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    
    return null;
  }
  
  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}