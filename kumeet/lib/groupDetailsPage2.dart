import 'package:flutter/material.dart';
import 'package:kumeet/groupEventPage2.dart';
import 'package:kumeet/groupMembersPage.dart'; // Ensure this page exists
import 'group.dart';
import 'groupService.dart';
import 'editGroupPage.dart';

class GroupDetailsPage2 extends StatefulWidget {
  final Group group;

  const GroupDetailsPage2({super.key, required this.group});

  @override
  _GroupDetailsPage2State createState() => _GroupDetailsPage2State();
}

class _GroupDetailsPage2State extends State<GroupDetailsPage2> {
  final GroupService _groupService = GroupService();
  bool _isProcessing = false;

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isProcessing = true;
      });
      final success = await _groupService.deleteGroup(widget.group);
      setState(() {
        _isProcessing = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Group "${widget.group.name}" deleted successfully.'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete group.')),
        );
      }
    }
  }

  Future<void> _updateGroup(Group updatedGroup) async {
    setState(() {
      _isProcessing = true;
    });
    final success =
        await _groupService.updateGroup(updatedGroup, widget.group.id);
    setState(() {
      _isProcessing = false;
    });
    if (success) {
      setState(() {
        widget.group.name = updatedGroup.name;
        widget.group.capacity = updatedGroup.capacity;
        widget.group.categories = updatedGroup.categories;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group "${updatedGroup.name}" updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update group.')),
      );
    }
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGroupPage(
          group: widget.group,
          onGroupUpdated: (updatedGroup) async {
            await _updateGroup(updatedGroup);
          },
        ),
      ),
    );
  }

  void _seeEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupEventsPage2(group: widget.group),
      ),
    );
  }

  void _navigateToGroupMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupMembersPage(
          groupId: widget.group.id!,
          groupName: widget.group.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        centerTitle: true,
      ),
      body: _isProcessing
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GroupImage(imagePath: 'images/group_image1.png'),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: _navigateToGroupMembers,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Group Members',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _seeEvents,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'See Events',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _navigateToEditPage,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Update Group',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _confirmDelete,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete Group',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
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
