import 'package:flutter/material.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/widgets/timeline_item.dart';

class TimelineList extends StatelessWidget {
  final List<Memory> memories;
  final Function(Memory) onTapMemory;

  const TimelineList({
    Key? key,
    required this.memories,
    required this.onTapMemory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort memories by date (newest first)
    final sortedMemories = List<Memory>.from(memories)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 24, bottom: 80),
      itemCount: sortedMemories.length,
      itemBuilder: (context, index) {
        final memory = sortedMemories[index];
        return TimelineItem(
          memory: memory,
          onTap: () => onTapMemory(memory),
          isFirst: index == 0,
          isLast: index == sortedMemories.length - 1,
        );
      },
    );
  }
}