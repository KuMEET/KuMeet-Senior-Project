import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'group.dart';
import 'group_service.dart';
import 'groupEventsPage.dart';
import 'package:kumeet/login_page.dart';

class GroupDetailsPage extends StatefulWidget {
  final Group group;

  const GroupDetailsPage({super.key, required this.group});

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  bool _isJoining = false;
  bool _isAlreadyMember = false;
  String? userName = GlobalState().userName;
  final GroupService _groupService = GroupService();

  @override
  void initState() {
    super.initState();
    _checkMembership();
  }

  Future<void> _checkMembership() async {
    try {
      List<Group> userGroups = await _groupService.getGroupsByUser(userName!);
      if (userGroups.any((group) => group.id == widget.group.id)) {
        setState(() {
          _isAlreadyMember = true;
        });
      }
    } catch (e) {
      print("Error checking membership: $e");
    }
  }

  Future<void> _joinGroup() async {
    if (_isAlreadyMember) return;  // Check if user is already a member

    setState(() {
      _isJoining = true;
    });

    final url = Uri.parse('http://localhost:8080/api/add-to-group/$userName/${widget.group.id}');
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${widget.group.name}!'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _isAlreadyMember = true;
        });
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isJoining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GroupImage(imagePath: 'images/group_image1.png'),
            const SizedBox(height: 16),
            GroupInfo(
              title: widget.group.name,
              capacity: widget.group.capacity,
              category: widget.group.categories,
            ),
            const SizedBox(height: 24),
            JoinButton(
              title: widget.group.name,
              isJoining: _isJoining,
              isAlreadyMember: _isAlreadyMember,
              onJoin: _joinGroup,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupEventsPage(group: widget.group),
                  ),
                );
              },
              child: const Text('See Events'),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupImage extends StatelessWidget {
  final String imagePath;

  const GroupImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }
}

class GroupInfo extends StatelessWidget {
  final String title;
  final int capacity;
  final String category;

  const GroupInfo({
    super.key,
    required this.title,
    required this.capacity,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Capacity: $capacity',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'Category: $category',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class JoinButton extends StatelessWidget {
  final String title;
  final bool isJoining;
  final bool isAlreadyMember;
  final VoidCallback onJoin;

  const JoinButton({
    super.key,
    required this.title,
    required this.isJoining,
    required this.isAlreadyMember,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isAlreadyMember ? null : isJoining ? null : onJoin,
      child: isJoining
          ? const CircularProgressIndicator()
          : Text(
              isAlreadyMember ? 'Already a Member' : 'Join $title',
              style: const TextStyle(fontSize: 18),
            ),
    );
  }
}
