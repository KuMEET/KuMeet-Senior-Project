import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'group.dart';
import 'group_service.dart';
import 'group_card.dart';
import 'createEvent_page.dart';

class OwnedGroupsPage extends StatefulWidget {
  const OwnedGroupsPage({super.key});

  @override
  _OwnedGroupsPageState createState() => _OwnedGroupsPageState();
}

class _OwnedGroupsPageState extends State<OwnedGroupsPage> {
  List<Group> ownedGroups = [];
  bool isLoading = true;
  final GroupService groupService = GroupService();
  String? userName = GlobalState().userName;

  @override
  void initState() {
    super.initState();
    fetchOwnedGroups();
  }

  Future<void> fetchOwnedGroups() async {
    try {
      final groups = await groupService.getOwnedGroups(userName!);
      print('Fetched ${groups.length} owned groups for user: $userName');
      setState(() {
        ownedGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load owned groups: $e')),
      );
    }
  }

  Future<void> _confirmGroupSelection(BuildContext context, Group group) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Group Selection'),
        content: Text('Do you want to create an event for the group "${group.name}"?'),
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

    if (confirmed == true) {
      // Navigate to Create Event Page with the selected group
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateEventPage(selectedGroup: group),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owned Groups'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            )
          : ownedGroups.isEmpty
              ? Center(
                  child: Text(
                    'No owned groups found.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: ownedGroups.length,
                  itemBuilder: (context, index) {
                    final group = ownedGroups[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: GroupCard(
                        title: group.name,
                        imagePath: 'images/group_image.png',
                        onTap: () => _confirmGroupSelection(context, group),
                      ),
                    );
                  },
                ),
    );
  }
}
