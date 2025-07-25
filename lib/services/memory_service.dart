import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memmerli/models/memory.dart';
import 'package:uuid/uuid.dart';

class MemoryService {
  static const String _memoriesKey = 'user_memories';
  static final _uuid = Uuid();

  // Get all memories for current user
  static Future<List<Memory>> getUserMemories(String userId) async {
    final memories = await _getMemories();
    return memories.where((memory) => memory.userId == userId).toList();
  }

  // Get a specific memory by ID
  static Future<Memory?> getMemoryById(String memoryId) async {
    final memories = await _getMemories();
    try {
      return memories.firstWhere((memory) => memory.id == memoryId);
    } catch (e) {
      return null;
    }
  }

  // Add a new memory
  static Future<Memory> addMemory({
    required String userId,
    required String title,
    required String description,
    required DateTime date,
    String? imagePath,
    String? videoPath,
    MemoryType type = MemoryType.memory,
  }) async {
    final memories = await _getMemories();
    final now = DateTime.now();

    final newMemory = Memory(
      id: _uuid.v4(),
      userId: userId,
      title: title,
      description: description,
      date: date,
      imagePath: imagePath,
      videoPath: videoPath,
      createdAt: now,
      updatedAt: now,
      type: type,
    );

    memories.add(newMemory);
    await _saveMemories(memories);
    return newMemory;
  }

  // Update an existing memory
  static Future<Memory?> updateMemory(Memory updatedMemory) async {
    final memories = await _getMemories();
    final index = memories.indexWhere((memory) => memory.id == updatedMemory.id);

    if (index != -1) {
      // Update the memory with the latest timestamp
      final memoryWithUpdatedTime = updatedMemory.copyWith(
        updatedAt: DateTime.now(),
      );
      
      memories[index] = memoryWithUpdatedTime;
      await _saveMemories(memories);
      return memoryWithUpdatedTime;
    }

    return null;
  }

  // Delete a memory
  static Future<bool> deleteMemory(String memoryId) async {
    final memories = await _getMemories();
    final initialLength = memories.length;
    
    memories.removeWhere((memory) => memory.id == memoryId);
    
    if (memories.length != initialLength) {
      await _saveMemories(memories);
      return true;
    }
    
    return false;
  }

  // Private helper to get all memories
  static Future<List<Memory>> _getMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = prefs.getString(_memoriesKey);

    if (memoriesJson != null) {
      final List<dynamic> decodedList = jsonDecode(memoriesJson);
      return decodedList.map((item) => Memory.fromJson(item)).toList();
    }

    return [];
  }

  // Private helper to save all memories
  static Future<void> _saveMemories(List<Memory> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final memoriesJson = jsonEncode(memories.map((memory) => memory.toJson()).toList());
    await prefs.setString(_memoriesKey, memoriesJson);
  }

  // Create sample data for testing
  static Future<void> createSampleData(String userId) async {
    // No sample data will be created so you can test the empty state
    // If you want to add sample data, uncomment the code below
    
    /*
    final memories = await _getMemories();
    
    // Only create sample data if there are no memories for this user
    if (memories.any((memory) => memory.userId == userId)) {
      return;
    }

    final now = DateTime.now();
    final sampleMemories = [
      Memory(
        id: _uuid.v4(),
        userId: userId,
        title: "My Grandfather",
        description: "Remembering grandpa's stories during summer evenings. He used to tell us tales about his adventures as a young man.",
        date: DateTime(now.year - 2, now.month, now.day),
        imagePath: null,
        videoPath: null,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      // Add more sample memories here if needed
    ];

    memories.addAll(sampleMemories);
    await _saveMemories(memories);
    */
  }
}