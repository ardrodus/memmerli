import 'package:flutter/material.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/screens/memory_entry_screen.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/theme/app_colors.dart';
import 'package:memmerli/widgets/app_drawer.dart';
import 'package:memmerli/widgets/memory_selection_card.dart';

/// A standalone screen that displays the empty state view
/// to guide users to create their first memory or recipe.
class MemorySelectionScreen extends StatefulWidget {
  const MemorySelectionScreen({Key? key}) : super(key: key);

  @override
  State<MemorySelectionScreen> createState() => _MemorySelectionScreenState();
}

class _MemorySelectionScreenState extends State<MemorySelectionScreen> {
  bool _isLoading = true;
  String _userId = '';
  bool _hasError = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Get current user
      final user = await AuthService.getCurrentUser();
      if (user == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      _userId = user['id'] as String;
      _username = user['username'] as String;

      setState(() {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
        elevation: 0,
      ),
      drawer: const AppDrawer(currentRoute: '/memory-selection'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome header
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.accent1.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $_username!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Begin preserving your special memories by creating your first entry below.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary1,
                  ),
                ),
              ],
            ),
          ),
          
          // Empty state view with creation options
          MemorySelectionView(
            onCreateMemory: _navigateToMemoryEntry,
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
            onPressed: _loadUserData,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}