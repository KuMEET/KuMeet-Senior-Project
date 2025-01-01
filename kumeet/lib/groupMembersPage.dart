import 'package:flutter/material.dart';
import 'package:kumeet/groupService.dart';
import 'package:kumeet/loginPage.dart';
import 'user.dart'; // Ensure you have this User model defined

class GroupMembersPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupMembersPage({Key? key, required this.groupId, required this.groupName}) : super(key: key);

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  final GroupService groupService = GroupService();
  late Future<List<User>> _membersFuture;
  late Future<List<User>> _adminsFuture;

  String? loggedInUsername = GlobalState().userName; // Get the current user's username

  @override
  void initState() {
    super.initState();
    _membersFuture = groupService.showMembersOfGroup(widget.groupId);
    _adminsFuture = groupService.showAdminsOfGroup(widget.groupId);
  }

  Future<void> _deleteMember(String userName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to remove this member from the group?'),
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
      final success = await groupService.deleteMemberFromGroup(userName, widget.groupId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName removed successfully!')),
        );
        setState(() {
          _membersFuture = groupService.showMembersOfGroup(widget.groupId); // Refresh the member list
          _adminsFuture = groupService.showAdminsOfGroup(widget.groupId); // Refresh admins list
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove the member.')),
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
      final success = await groupService.updateMemberRoleInGroup(userName, widget.groupId, newRole);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName role updated to $newRole!')),
        );
        setState(() {
          _membersFuture = groupService.showMembersOfGroup(widget.groupId); // Refresh the member list
          _adminsFuture = groupService.showAdminsOfGroup(widget.groupId); // Refresh admins list
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update role.')),
        );
      }
    }
  }

  Widget _buildUserList(List<User> users, bool isAdminList) {
    // Filter out the logged-in user from the admins list
    final filteredUsers = isAdminList && loggedInUsername != null
        ? users.where((user) => user.userName != loggedInUsername).toList()
        : users;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        final userRole = user.role?.isNotEmpty == true ? user.role : 'Member';

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
                user.name[0], // Display the first letter of the name
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              '${user.name} ${user.surname}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: isAdminList
                ? const Text('Role: Admin')
                : Row(
                    children: [
                      const Text('Role: '),
                      DropdownButton<String>(
                        value: userRole,
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
              tooltip: 'Remove Member',
              onPressed: () => _deleteMember(user.userName),
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
        title: Text('${widget.groupName} Members & Admins'),
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
                  return const Center(child: Text('No members found for this group.'));
                }

                final members = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${widget.groupName}\'s Members',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildUserList(members, false),
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
                  return const Center(child: Text('No admins found for this group.'));
                }

                final admins = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${widget.groupName}\'s Admins',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildUserList(admins, true),
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
