import 'package:flutter/material.dart';
import 'event_service.dart';
import 'userReference.dart';

class PendingUsersPage extends StatefulWidget {
  final String eventId;

  const PendingUsersPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _PendingUsersPageState createState() => _PendingUsersPageState();
}

class _PendingUsersPageState extends State<PendingUsersPage> {
  final EventService eventService = EventService();
  late Future<List<UserReference>> _pendingUsersFuture;

  @override
  void initState() {
    super.initState();
    _pendingUsersFuture = eventService.getPendingUsersForEvent(widget.eventId);
  }

  Future<void> _approveUser(String userId) async {
    try {
      await eventService.approveUserRequest(widget.eventId, userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User approved successfully.')),
      );
      setState(() {
        _pendingUsersFuture = eventService.getPendingUsersForEvent(widget.eventId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve user: $e')),
      );
    }
  }

  Future<void> _denyUser(String userId) async {
    try {
      await eventService.rejectUserRequest(widget.eventId, userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User denied successfully.')),
      );
      setState(() {
        _pendingUsersFuture = eventService.getPendingUsersForEvent(widget.eventId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deny user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Users'),
      ),
      body: FutureBuilder<List<UserReference>>(
        future: _pendingUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending users.'));
          } else {
            final pendingUsers = snapshot.data!;
            return ListView.builder(
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                final user = pendingUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('User ID: ${user.userId}'),
                    subtitle: Text('Joined At: ${user.joinAt}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approveUser(user.userId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _denyUser(user.userId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
