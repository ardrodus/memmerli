import 'package:shared_preferences/shared_preferences.dart';

class DataClearer {
  // Clear all memory data
  static Future<void> clearAllMemories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_memories');
    print('All memory data cleared');
  }
  
  // Clear all stored data including user login
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All application data cleared');
  }
}