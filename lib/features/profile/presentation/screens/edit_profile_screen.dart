// lib/features/profile/presentation/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../providers/user_profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfileEntity profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _displayNameController;
  late TextEditingController _phoneNumberController;

  File? _selectedImage;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Sports options
  final List<String> _availableSports = [
    'Badminton',
    'Cricket',
    'Football',
    'Basketball',
    'Tennis',
    'Table Tennis',
    'Volleyball',
    'Squash',
  ];

  late List<String> _selectedSports;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.profile.displayName);
    _phoneNumberController = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _selectedSports = List.from(widget.profile.sports);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one sport'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update profile with new information
      // Note: Currently only updates sports. To update display name and phone,
      // you'll need to create additional methods in the controller

      // TODO: If image is selected, upload it to Firebase Storage first
      // and get the URL, then update the profile with the new URL

      // Update sports through the controller
      await ref.read(userProfileControllerProvider.notifier).updateSports(
        userId: widget.profile.userId,
        sports: _selectedSports,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Photo Section
              _buildProfilePhotoSection(),

              const SizedBox(height: 30),

              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Name
                    _buildTextField(
                      controller: _displayNameController,
                      label: 'Display Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Display name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Display name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Email (Read-only)
                    _buildReadOnlyField(
                      label: 'Email',
                      value: widget.profile.email,
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 20),

                    // Phone Number
                    _buildTextField(
                      controller: _phoneNumberController,
                      label: 'Phone Number (Optional)',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Sports Selection
                    Text(
                      'Sports You Play',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSportsSelection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.grey200,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : (widget.profile.photoUrl != null
                  ? NetworkImage(widget.profile.photoUrl!)
                  : null) as ImageProvider?,
              child: _selectedImage == null && widget.profile.photoUrl == null
                  ? Icon(
                Icons.person,
                size: 60,
                color: AppColors.grey600,
              )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to change photo',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: AppColors.grey900),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey600),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey600),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportsSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableSports.map((sport) {
        final isSelected = _selectedSports.contains(sport);
        return FilterChip(
          label: Text(sport),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedSports.add(sport);
              } else {
                _selectedSports.remove(sport);
              }
            });
          },
          backgroundColor: AppColors.grey100,
          selectedColor: AppColors.primaryBlue.withOpacity(0.2),
          checkmarkColor: AppColors.primaryBlue,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey900,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        );
      }).toList(),
    );
  }
}