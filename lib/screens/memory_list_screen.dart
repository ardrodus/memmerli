import 'package:flutter/material.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/screens/memory_entry_screen.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/services/memory_service.dart';
import 'package:memmerli/theme/app_colors.dart';
import 'package:memmerli/widgets/memory_card.dart';

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

  void _navigateToMemoryEntry({Memory? memory}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemoryEntryScreen(
          userId: _userId,
          memory: memory,
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
        title: const Text('Memmerli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState()
              : _memories.isEmpty
                  ? _buildEmptyState()
                  : _buildMemoriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMemoryEntry(),
        backgroundColor: AppColors.primary1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.accent1.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_album_outlined,
              size: 60,
              color: AppColors.primary1.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Memories Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary2,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Add your first memory by tapping the + button below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary1,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _navigateToMemoryEntry(),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Memory'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        itemCount: _memories.length,
        itemBuilder: (context, index) {
          final memory = _memories[index];
          return MemoryCard(
            memory: memory,
            onTap: () => _navigateToMemoryEntry(memory: memory),
          );
        },
      ),
    );
  }
}