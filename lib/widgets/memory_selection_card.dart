import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/theme/app_colors.dart';

/// A single card for the memory selection view that displays an icon, title, description, and action button.
class MemorySelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconAsset;
  final String buttonLabel;
  final Color accentColor;
  final VoidCallback onPressed;

  const MemorySelectionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.buttonLabel,
    required this.accentColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
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
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Icon from assets
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
                      '/assets/images/$iconAsset',
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
                      'assets/images/$iconAsset',
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary2,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  onPressed: onPressed,
                  icon: const Icon(Icons.add),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
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
    );
  }
}

/// A widget that displays memory selection cards for memories and recipes.
class MemorySelectionView extends StatelessWidget {
  final void Function({Memory? memory, MemoryType memoryType}) onCreateMemory;

  const MemorySelectionView({
    Key? key,
    required this.onCreateMemory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          // Memory Card
          MemorySelectionCard(
            title: 'Add Your First Memory',
            description: 'Create a special memory of your loved one by adding photos, videos, and descriptions.',
            iconAsset: 'MemoryIcon.png',
            buttonLabel: 'Create Memory',
            accentColor: AppColors.secondary1,
            onPressed: () => onCreateMemory(memoryType: MemoryType.memory),
          ),
          
          const SizedBox(height: 24),
          
          // Recipe Card
          MemorySelectionCard(
            title: 'Add Cherished Recipe',
            description: 'Preserve favorite recipes from your loved ones. Include photos, ingredients, and preparation steps.',
            iconAsset: 'RecipeIcon.png',
            buttonLabel: 'Add Recipe',
            accentColor: AppColors.secondary2,
            onPressed: () => onCreateMemory(memoryType: MemoryType.recipe),
          ),
        ],
      ),
    );
  }
}