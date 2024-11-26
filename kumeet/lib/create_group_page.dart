import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For image picking

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  File? _selectedImage; // To store the selected image file

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      final groupName = _groupNameController.text;

      // Include _selectedImage in the group creation logic if necessary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group "$groupName" created successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, 
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GroupImagePicker(
                selectedImage: _selectedImage,
                onImagePick: _pickImage,
              ),
              const SizedBox(height: 16),
              GroupNameField(controller: _groupNameController),
              const SizedBox(height: 24),
              CreateGroupButton(onPressed: _createGroup),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupImagePicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onImagePick;

  const GroupImagePicker({
    super.key,
    required this.selectedImage,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImagePick, // Call the image picker function
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[800], 
          border: Border.all(color: Colors.white, width: 1), 
        ),
        child: selectedImage == null
            ? const Center(
                child: Text(
                  'Tap to select a group image',
                  style: TextStyle(color: Colors.white70), 
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ),
    );
  }
}

class GroupNameField extends StatelessWidget {
  final TextEditingController controller;

  const GroupNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Group Name',
        labelStyle: const TextStyle(color: Colors.white70), 
        prefixIcon: const Icon(Icons.group, color: Colors.white), 
        filled: true,
        fillColor: Colors.grey[800], 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white), 
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a group name';
        }
        return null;
      },
    );
  }
}

class CreateGroupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateGroupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: const Text(
        'Create Group',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
