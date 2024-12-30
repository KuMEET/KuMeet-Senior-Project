import 'package:flutter/material.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/user.dart';
import 'package:kumeet/user_service.dart';
import 'package:kumeet/group_card.dart';
import 'package:kumeet/group_details_page2.dart';  // Make sure this is the correct import for GroupDetailsPage2
import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late UserService _userService;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _surnameController;
  late User _currentUser;
  List<Group> _ownedGroups = [];
  bool _isLoading = true;
  String? userName = GlobalState().userName;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _surnameController = TextEditingController();
    _fetchUserData();
    _fetchOwnedGroups();
  }

  Future<void> _fetchUserData() async {
    try {
      String userName = this.userName!;
      _currentUser = await _userService.find(userName);
      setState(() {
        _isLoading = false;
        _nameController.text = _currentUser.name;
        _emailController.text = _currentUser.email;
        _surnameController.text = _currentUser.surname;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  Future<void> _fetchOwnedGroups() async {
    try {
      GroupService groupService = GroupService();
      _ownedGroups = await groupService.getOwnedGroups(userName!);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load owned groups: $e')));
    }
  }

  void _updateUser() async {
    setState(() => _isLoading = true);
    try {
      _currentUser.name = _nameController.text;
      _currentUser.email = _emailController.text;
      _currentUser.surname = _surnameController.text;
      await _userService.updateUser(_currentUser.userName, _currentUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
                  TextField(controller: _surnameController, decoration: InputDecoration(labelText: 'Surname')),
                  TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
                  ElevatedButton(onPressed: _updateUser, child: Text('Update Profile')),
                  const SizedBox(height: 20),
                  if (_ownedGroups.isNotEmpty) ...[
                    Text("Owned Groups", style: Theme.of(context).textTheme.titleLarge),
                    Wrap(
  spacing: 10, // Horizontal space between cards
  runSpacing: 10, // Vertical space between cards
  children: _ownedGroups.map((group) => GroupCard(
    group: group, // Pass the entire Group object
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupDetailsPage2(group: group),
        ),
      );
    },
  )).toList(),
),
                  ],
                ],
              ),
            ),
    );
  }
}
