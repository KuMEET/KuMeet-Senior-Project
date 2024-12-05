import 'package:flutter/material.dart';
import 'group.dart';
import 'group_service.dart';
import 'group_card.dart';
import 'group_details_page2.dart'; // Ensure this import points to GroupDetailsPage2
import 'package:kumeet/login_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owned Groups', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : ownedGroups.isEmpty
              ? const Center(
                  child: Text(
                    'No owned groups found.',
                    style: TextStyle(color: Colors.white),
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
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupDetailsPage2(
                                group: group,
                                onGroupUpdated: fetchOwnedGroups,
                                onGroupDeleted: fetchOwnedGroups,
                              ),
                            ),
                          );
                          if (result == true) {
                            fetchOwnedGroups();
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
