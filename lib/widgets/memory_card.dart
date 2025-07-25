import 'package:flutter/material.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/theme/app_colors.dart';
import 'package:intl/intl.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;

  const MemoryCard({
    Key? key,
    required this.memory,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Memory image or placeholder
            _buildImageSection(),
            
            // Memory content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          memory.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Date
                      Text(
                        DateFormat('MMM dd, yyyy').format(memory.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary1,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    memory.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    // If there's an image path, show image placeholder with photo icon
    if (memory.imagePath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: AppColors.accent1.withOpacity(0.3),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: AppColors.primary1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // If there's a video path, show a video thumbnail with play button
    if (memory.videoPath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: AppColors.primary2.withOpacity(0.1),
                child: const Center(
                  child: Icon(
                    Icons.video_library,
                    size: 40,
                    color: AppColors.primary2,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary1.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // Otherwise show a placeholder
    return _buildImagePlaceholder();
  }
  
  Widget _buildImagePlaceholder() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.accent1.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.photo,
              size: 40,
              color: AppColors.primary1.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}