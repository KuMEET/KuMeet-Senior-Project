import 'package:flutter/material.dart';
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
  String? UserName = GlobalState().userName;
  final GroupService _groupService = GroupService();
  String? _selectedCategory;

  // List of categories
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
    "Travel & Outdoor"
  ];

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      // Handle group creation

      final newGroup = Group(
        name: _groupNameController.text,
        capacity: int.parse(_capacityController.text),
        categories: _selectedCategory!, visibility: true,
      );
      final success = await _groupService.createGroup(newGroup, UserName!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully!')),
        );
        Navigator.pop(context); // Navigate back after successful creation
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
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
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
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a group name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || int.tryParse(value) == null
                    ? 'Please enter a valid capacity'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null
                    ? 'Please select a category'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createGroup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
