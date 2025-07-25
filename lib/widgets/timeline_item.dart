import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/theme/app_colors.dart';

class TimelineItem extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    Key? key,
    required this.memory,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and dot
            _buildTimelineColumn(),
            
            // Memory content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                child: _buildMemoryCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineColumn() {
    return SizedBox(
      width: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Line above the dot
          if (!isFirst)
            Container(
              width: 2,
              height: 30,
              color: AppColors.primary1,
            ),
          
          // Date and dot
          Column(
            children: [
              // Month
              Text(
                DateFormat('MMM').format(memory.date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary1,
                ),
              ),
              
              // Day
              Text(
                DateFormat('dd').format(memory.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary2,
                ),
              ),
              
              // Year
              Text(
                DateFormat('yyyy').format(memory.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary1,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Dot
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary1,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent2,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
          
          // Line below the dot
          if (!isLast)
            Flexible(
              child: Container(
                width: 2,
                height: 100,
                color: AppColors.primary1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMemoryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary2.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                // Title
                Text(
                  memory.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  memory.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    // If there's an image path
    if (memory.imagePath != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(
          height: 140,
          width: double.infinity,
          color: AppColors.accent1.withOpacity(0.3),
          child: const Center(
            child: Icon(
              Icons.image,
              size: 40,
              color: AppColors.primary1,
            ),
          ),
        ),
      );
    }
    
    // If there's a video path
    if (memory.videoPath != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              color: AppColors.accent1.withOpacity(0.3),
              child: const Center(
                child: Icon(
                  Icons.video_library,
                  size: 40,
                  color: AppColors.primary1,
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
        ),
      );
    }
    
    // No image or video
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: 20,
        width: double.infinity,
        color: AppColors.secondary1.withOpacity(0.5),
      ),
    );
  }
}