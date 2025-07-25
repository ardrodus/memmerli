import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memmerli/models/memory.dart';
import 'package:memmerli/services/memory_service.dart';
import 'package:memmerli/theme/app_colors.dart';

class MemoryEntryScreen extends StatefulWidget {
  final String userId;
  final Memory? memory;

  const MemoryEntryScreen({
    Key? key,
    required this.userId,
    this.memory,
  }) : super(key: key);

  @override
  State<MemoryEntryScreen> createState() => _MemoryEntryScreenState();
}

class _MemoryEntryScreenState extends State<MemoryEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  String? _selectedImagePath;
  String? _selectedVideoPath;
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.memory != null;
    
    // Initialize controllers with existing memory data or empty strings
    _titleController = TextEditingController(text: widget.memory?.title ?? '');
    _descriptionController = TextEditingController(text: widget.memory?.description ?? '');
    _selectedDate = widget.memory?.date ?? DateTime.now();
    _selectedImagePath = widget.memory?.imagePath;
    _selectedVideoPath = widget.memory?.videoPath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary1,
              onPrimary: AppColors.white,
              onSurface: AppColors.primary2,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Mock function for selecting an image
  Future<void> _pickImage() async {
    // In a real app, you'd use image_picker package
    // For now, we'll just simulate the selection
    setState(() {
      // Using a null path but marking as selected for demo purposes
      _selectedImagePath = 'selected_image';
      // Clear video if an image is selected
      _selectedVideoPath = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected')),
    );
  }

  // Mock function for selecting a video
  Future<void> _pickVideo() async {
    // In a real app, you'd use image_picker package
    // For now, we'll just simulate the selection
    setState(() {
      // Using a string to mark as selected for demo purposes
      _selectedVideoPath = 'selected_video';
      // Clear image if a video is selected
      _selectedImagePath = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video selected')),
    );
  }

  // Save the memory
  Future<void> _saveMemory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditMode && widget.memory != null) {
        // Update existing memory
        final updatedMemory = widget.memory!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          date: _selectedDate,
          imagePath: _selectedImagePath,
          videoPath: _selectedVideoPath,
        );
        
        await MemoryService.updateMemory(updatedMemory);
      } else {
        // Create new memory
        await MemoryService.addMemory(
          userId: widget.userId,
          title: _titleController.text,
          description: _descriptionController.text,
          date: _selectedDate,
          imagePath: _selectedImagePath,
          videoPath: _selectedVideoPath,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Delete the memory
  Future<void> _deleteMemory() async {
    if (!_isEditMode || widget.memory == null) {
      return;
    }

    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memory'),
        content: const Text('Are you sure you want to delete this memory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmDelete) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await MemoryService.deleteMemory(widget.memory!.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Memory' : 'New Memory'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deleteMemory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter a title for this memory',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Date picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMMM dd, yyyy').format(_selectedDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Icon(Icons.calendar_today, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Media section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Media',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.photo),
                                  label: const Text('Add Photo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedImagePath != null
                                        ? AppColors.primary1
                                        : AppColors.accent1,
                                    foregroundColor: _selectedImagePath != null
                                        ? AppColors.white
                                        : AppColors.primary2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickVideo,
                                  icon: const Icon(Icons.videocam),
                                  label: const Text('Add Video'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedVideoPath != null
                                        ? AppColors.primary1
                                        : AppColors.accent1,
                                    foregroundColor: _selectedVideoPath != null
                                        ? AppColors.white
                                        : AppColors.primary2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Display selected media preview
                          if (_selectedImagePath != null || _selectedVideoPath != null)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.accent1.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.accent1),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _selectedImagePath != null
                                          ? Icons.image
                                          : Icons.videocam,
                                      size: 40,
                                      color: AppColors.primary1,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _selectedImagePath != null
                                          ? 'Image Selected'
                                          : 'Video Selected',
                                      style: const TextStyle(
                                        color: AppColors.primary2,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedImagePath = null;
                                          _selectedVideoPath = null;
                                        });
                                      },
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Write about this memory...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _saveMemory,
                          child: Text(
                            _isEditMode ? 'Save Changes' : 'Save Memory',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}