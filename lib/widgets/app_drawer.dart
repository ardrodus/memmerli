import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:memmerli/screens/memory_list_screen.dart';
import 'package:memmerli/screens/profile_screen.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  
  const AppDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildMenuItem(
            context: context,
            icon: Icons.photo_library,
            title: 'Memories',
            isSelected: currentRoute == '/memories',
            onTap: () {
              if (currentRoute != '/memories') {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemoryListScreen(),
                  ),
                );
              } else {
                Navigator.pop(context); // Just close drawer
              }
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.person,
            title: 'Profile',
            isSelected: currentRoute == '/profile',
            onTap: () {
              if (currentRoute != '/profile') {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else {
                Navigator.pop(context); // Just close drawer
              }
            },
          ),
          const Divider(),
          _buildMenuItem(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: AppColors.primary1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent2,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent2,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: kIsWeb 
                ? Image.network(
                    '/assets/images/LoginIcon.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.memory,
                        size: 30,
                        color: AppColors.primary1,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/LoginIcon.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.memory,
                        size: 30,
                        color: AppColors.primary1,
                      );
                    },
                  ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Memmerli',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Remember your loved ones',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary1 : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary1 : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      tileColor: isSelected ? AppColors.accent1.withOpacity(0.2) : null,
      onTap: onTap,
    );
  }
}