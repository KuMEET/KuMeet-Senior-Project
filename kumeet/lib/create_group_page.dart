import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For image picking

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

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
        title: const Text('Create Group'),
        backgroundColor: Colors.blueGrey,
      ),
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
    Key? key,
    required this.selectedImage,
    required this.onImagePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImagePick, // Call the image picker function
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          border: Border.all(color: Colors.blueGrey, width: 1),
        ),
        child: selectedImage == null
            ? const Center(
                child: Text(
                  'Tap to select a group image',
                  style: TextStyle(color: Colors.grey),
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

  const GroupNameField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Group Name',
        prefixIcon: const Icon(Icons.group, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
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

  const CreateGroupButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
