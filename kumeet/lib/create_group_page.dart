import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'group.dart';
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
  final GroupService _groupService = GroupService();
  bool _isLoading = false;
  String? UserName = GlobalState().userName;
  void _createGroup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final group = Group(name: _groupNameController.text, capacity: int.parse(_capacityController.text));

      final success = await _groupService.createGroup(group, UserName!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group "${group.name}" created successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group')),
        );
      }

      setState(() {
        _isLoading = false;
      });
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
              // Group Name Input Field
              GroupNameField(controller: _groupNameController),
              const SizedBox(height: 16),

              // Capacity Input Field
              CapacityField(controller: _capacityController),
              const SizedBox(height: 24),

              // Create Group Button
              CreateGroupButton(onPressed: _isLoading ? null : _createGroup),
            ],
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
class CapacityField extends StatelessWidget {
  final TextEditingController controller;

  const CapacityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Group Capacity',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.people, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number, // Restrict input to numbers
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the group capacity';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}

class CreateGroupButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CreateGroupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Create Group',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
