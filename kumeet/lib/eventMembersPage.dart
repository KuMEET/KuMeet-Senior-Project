import 'package:flutter/material.dart';
import 'package:kumeet/eventService.dart';
import 'package:kumeet/loginPage.dart';
import 'user.dart'; // Ensure you have this User model defined

class EventMembersPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  const EventMembersPage({Key? key, required this.eventId, required this.eventName}) : super(key: key);

  @override
  _EventMembersPageState createState() => _EventMembersPageState();
}

class _EventMembersPageState extends State<EventMembersPage> {
  final EventService eventService = EventService();
  late Future<List<User>> _membersFuture;
  late Future<List<User>> _adminsFuture;
  String? loggedInUserName = GlobalState().userName; // Retrieve the logged-in user's username

  @override
  void initState() {
    super.initState();
    _membersFuture = _fetchMembersWithDefaultRole();
    _adminsFuture = _fetchAdminsWithExclusion();
  }

  Future<List<User>> _fetchMembersWithDefaultRole() async {
    final members = await eventService.showMembers(widget.eventId);
    for (var member in members) {
      if (member.role == null || member.role!.isEmpty) {
        member.role = 'Member'; // Assign default role
      }
    }
    return members;
  }

  Future<List<User>> _fetchAdminsWithExclusion() async {
    final admins = await eventService.showAdmins(widget.eventId);
    return admins
        .where((admin) => admin.userName != loggedInUserName) // Exclude the logged-in user
        .map((admin) {
          admin.role = 'Admin'; // Ensure admin role is assigned
          return admin;
        })
        .toList();
  }

  Future<void> _deleteUser(String userName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to remove this user from the event?'),
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
      final success = await eventService.deleteMemberFromEvent(userName, widget.eventId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName removed successfully!')),
        );
        setState(() {
          _membersFuture = _fetchMembersWithDefaultRole(); // Refresh members
          _adminsFuture = _fetchAdminsWithExclusion(); // Refresh admins
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove the user.')),
        );
      }
    }
  }

  Future<void> _updateRole(String userName, String newRole) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Role Update'),
        content: Text('Change role to $newRole for $userName?'),
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
      final success = await eventService.updateMemberRoleInEvent(userName, widget.eventId, newRole);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName role updated to $newRole!')),
        );
        setState(() {
          _membersFuture = _fetchMembersWithDefaultRole();
          _adminsFuture = _fetchAdminsWithExclusion();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update role.')),
        );
      }
    }
  }

  Widget _buildUserList(List<User> users, String roleType) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Text(
                user.name[0],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              '${user.name} ${user.surname}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: roleType == 'Admin'
                ? const Text('Role: Admin')
                : Row(
                    children: [
                      const Text('Role: '),
                      DropdownButton<String>(
                        value: user.role,
                        onChanged: (newRole) {
                          if (newRole != null) {
                            _updateRole(user.userName, newRole);
                          }
                        },
                        items: ['Member', 'Admin'].map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Remove User',
              onPressed: () => _deleteUser(user.userName),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventName} Members & Admins'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<User>>(
              future: _membersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching members: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No members found for this event.'));
                }

                final members = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${widget.eventName} Members',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildUserList(members, 'Member'),
                  ],
                );
              },
            ),
            FutureBuilder<List<User>>(
              future: _adminsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching admins: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No admins found for this event.'));
                }

                final admins = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${widget.eventName} Admins',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildUserList(admins, 'Admin'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}