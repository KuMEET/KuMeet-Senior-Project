import 'package:flutter/material.dart';
import 'package:kumeet/group_service.dart';
import 'group.dart';
import 'package:kumeet/login_page.dart';

class GroupDetailsPage2 extends StatefulWidget {
  final Group group;
  final VoidCallback onGroupUpdated;
  final VoidCallback onGroupDeleted;

  const GroupDetailsPage2({
    Key? key,
    required this.group,
    required this.onGroupUpdated,
    required this.onGroupDeleted,
  }) : super(key: key);

  @override
  _GroupDetailsPage2State createState() => _GroupDetailsPage2State();
}

class _GroupDetailsPage2State extends State<GroupDetailsPage2> {
  bool _isProcessing = false;
  String? userName = GlobalState().userName;
  final GroupService groupService = GroupService();

  void _editGroup() {
    // Navigate to the edit group page
    // After editing, call widget.onGroupUpdated();
  }

  Future<void> _deleteGroup() async {
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
      try{
      final success = await groupService.deleteGroup(widget.group.id!);

      if (success) {
         widget.onGroupDeleted();
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Group "${widget.group.name}" deleted successfully.'),
             duration: const Duration(seconds: 2),
           ),
         );
         Navigator.of(context).pop(); // Navigate back after deletion
       } else {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Failed to delete group.'),
             duration: const Duration(seconds: 2),
           ),
         );
       }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting event: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GroupImage(imagePath: 'images/group_image.png'),
            const SizedBox(height: 16),
            GroupInfo(
              title: widget.group.name,
              capacity: widget.group.capacity,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isProcessing ? null : _editGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Edit Group',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _deleteGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Delete Group',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupImage extends StatelessWidget {
  final String imagePath;

  const GroupImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
        color: Colors.black.withOpacity(0.6),
        colorBlendMode: BlendMode.darken,
      ),
    );
  }
}

class GroupInfo extends StatelessWidget {
  final String title;
  final int capacity;

  const GroupInfo({
    Key? key,
    required this.title,
    required this.capacity,
  }) : super(key: key);

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
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Capacity: $capacity',
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }
}
