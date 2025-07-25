import 'package:flutter/material.dart';
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
  
  Widget _navigateToMemorySelection() {
    // Use addPostFrameCallback to navigate after the current frame is built
    // to avoid navigation during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/memory-selection');
    });
    // Return an empty container since we're navigating away
    return Container();
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
                  ? _navigateToMemorySelection()
                  : _buildMemoriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMemoryEntry(memoryType: MemoryType.memory),
        backgroundColor: AppColors.primary1,
        child: const Icon(Icons.add),
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