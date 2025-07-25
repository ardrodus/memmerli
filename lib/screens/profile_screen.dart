import 'package:flutter/material.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await AuthService.getCurrentUser();
    
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile avatar placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.accent1.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary1,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 80,
              color: AppColors.primary1,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // User name
          Text(
            _userInfo?['username'] ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary2,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // User email
          Text(
            _userInfo?['email'] ?? 'email@example.com',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary2.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Coming soon message
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent1.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.engineering,
                  size: 32,
                  color: AppColors.secondary1,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profile Settings Coming Soon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This feature is under development and will be available soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary2.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}