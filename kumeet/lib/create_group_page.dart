import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/login_page.dart';
import 'group_service.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _capacityController = TextEditingController();
  String? userName = GlobalState().userName;
  final GroupService _groupService = GroupService();
  String? _selectedCategory;
  File? _pickedImageFile;

  final List<String> _categories = [
    "Art & Culture",
    "Career & Business",
    "Dancing",
    "Games",
    "Music",
    "Science & Education",
    "Identity & Language",
    "Social Activities",
    "Sports & Fitness",
    "Travel & Outdoor",
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick an image')),
        );
        return;
      }

      final newGroup = Group(
        name: _groupNameController.text,
        capacity: int.parse(_capacityController.text),
        categories: _selectedCategory!,
        visibility: true,
      );

      final success = await _groupService.createGroup(newGroup, userName!, _pickedImageFile);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  filled: true,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a group name' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  filled: true,
                ),
                validator: (value) =>
                    value == null || int.tryParse(value) == null ? 'Please enter a valid capacity' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _pickedImageFile != null
                      ? Image.file(_pickedImageFile!, fit: BoxFit.cover)
                      : const Center(child: Text('Tap to select an image')),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _createGroup,
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}