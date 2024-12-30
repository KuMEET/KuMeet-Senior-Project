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
    if (_isAlreadyMember) return;

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
      appBar: AppBar(
        title: const Text('Group Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupImage(imagePath: 'images/group_image1.png'),
              const SizedBox(height: 24),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GroupInfo(
                    title: widget.group.name,
                    capacity: widget.group.capacity,
                    category: widget.group.categories,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: JoinButton(
                    title: widget.group.name,
                    isJoining: _isJoining,
                    isAlreadyMember: _isAlreadyMember,
                    onJoin: _joinGroup,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupEventsPage(group: widget.group),
                        ),
                      );
                    },
                    child: const Text(
                      'See Events',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 250,
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.people, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Capacity: $capacity',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.category, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 16),
            ),
          ],
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
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: isAlreadyMember ? null : isJoining ? null : onJoin,
      child: isJoining
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              isAlreadyMember ? 'Already a Member' : 'Join $title',
              style: const TextStyle(fontSize: 18),
            ),
    );
  }
}
