import 'package:flutter/material.dart';
import 'package:kumeet/create_group_page.dart';
import 'group_card.dart';
import 'group_details_page.dart';
import 'group_service.dart';
import 'group.dart';
import 'owned_groups_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupService _groupService = GroupService();
  List<Group> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  Future<void> _getGroups() async {
    try {
      final groups = await _groupService.getGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch groups: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Groups', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: SearchBar(),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OwnedGroupsPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepOrange,
          ),
          child: const Text('Go to Owned Groups'),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _groups.isEmpty
                  ? const Center(
                      child: Text(
                        'No groups available',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : GroupList(groups: _groups),
        ),
      ],
    ),
    floatingActionButton: const CreateGroupButton(),
    backgroundColor: Colors.grey[900],
  );
}

}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Groups',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class GroupList extends StatelessWidget {
  final List<Group> groups;

  const GroupList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GroupCard(
            title: group.name,
            imagePath: 'images/group_image.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsPage(group: group),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CreateGroupButton extends StatelessWidget {
  const CreateGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateGroupPage()),
        );
      },
      backgroundColor: Colors.deepOrange,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}