import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/screens/memory_entry_screen.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/services/memory_service.dart';
import 'package:memmerli/theme/app_colors.dart';
import 'package:memmerli/widgets/app_drawer.dart';
import 'package:memmerli/widgets/timeline_list.dart';

class MemoryListScreen extends StatefulWidget {
  const MemoryListScreen({Key? key}) : super(key: key);

  @override
  State<MemoryListScreen> createState() => _MemoryListScreenState();
}

class _MemoryListScreenState extends State<MemoryListScreen> {
  bool _isLoading = true;
  List<Memory> _memories = [];
  String _userId = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadUserAndMemories();
  }

  Future<void> _loadUserAndMemories() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Get current user
      final user = await AuthService.getCurrentUser();
      if (user == null) {
        // Handle the case where user is not logged in
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      _userId = user['id'] as String;

      // Create sample data if needed
      await MemoryService.createSampleData(_userId);

      // Load memories
      final memories = await MemoryService.getUserMemories(_userId);
      setState(() {
        _memories = memories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _navigateToMemoryEntry({Memory? memory, MemoryType memoryType = MemoryType.memory}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemoryEntryScreen(
          userId: _userId,
          memory: memory,
          memoryType: memoryType,
        ),
      ),
    ).then((_) {
      // Refresh memories list when returning from memory entry
      _loadUserAndMemories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
        elevation: 0,
      ),
      drawer: const AppDrawer(currentRoute: '/memories'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState()
              : _memories.isEmpty
                  ? _buildEmptyState()
                  : _buildMemoriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMemoryEntry(memoryType: MemoryType.memory),
        backgroundColor: AppColors.primary1,
        child: const Icon(Icons.add),
      ),
    );
  }
  

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          // First card - Memory Card
          InkWell(
            onTap: () => _navigateToMemoryEntry(memoryType: MemoryType.memory),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary2.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.accent1,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card header with accent color
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Memory Icon from assets
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accent1.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: kIsWeb 
                        ? Image.network(
                            '/assets/images/MemoryIcon.png',
                            width: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading web image: $error');
                              return const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: AppColors.primary1,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/MemoryIcon.png',
                            width: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading asset image: $error');
                              return const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: AppColors.primary1,
                              );
                            },
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  const Text(
                    'Add Your First Memory',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Create a special memory of your loved one by adding photos, videos, and descriptions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary1,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Button
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToMemoryEntry(memoryType: MemoryType.memory),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Memory'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Second card - Recipe Card
          InkWell(
            onTap: () => _navigateToMemoryEntry(memoryType: MemoryType.recipe),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary2.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.accent1,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card header with accent color
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary2,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recipe Icon from assets
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accent1.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: kIsWeb 
                        ? Image.network(
                            '/assets/images/RecipeIcon.png',
                            width: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading web image: $error');
                              return const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: AppColors.primary1,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/RecipeIcon.png',
                            width: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading asset image: $error');
                              return const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: AppColors.primary1,
                              );
                            },
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  const Text(
                    'Add Cherished Recipe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Preserve favorite recipes from your loved ones. Include photos, ingredients, and preparation steps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary1,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Button
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToMemoryEntry(memoryType: MemoryType.recipe),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Recipe'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary2,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUserAndMemories,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoriesList() {
    return RefreshIndicator(
      onRefresh: _loadUserAndMemories,
      child: TimelineList(
        memories: _memories,
        onTapMemory: (memory) => _navigateToMemoryEntry(memory: memory),
      ),
    );
  }
}