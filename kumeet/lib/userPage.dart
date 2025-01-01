import 'package:flutter/material.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/groupService.dart';
import 'package:kumeet/groupCard.dart';
import 'package:kumeet/groupDetailsPage2.dart';
import 'package:kumeet/loginPage.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<UserPage> {
  final GroupService _groupService = GroupService();
  List<Group> _ownedGroups = [];
  bool _isLoadingGroups = true;
  String? userName = GlobalState().userName;

  @override
  void initState() {
    super.initState();
    _fetchOwnedGroups();
  }

  Future<void> _fetchOwnedGroups() async {
    try {
      final groups = await _groupService.getOwnedGroups(userName!);
      setState(() {
        _ownedGroups = groups;
        _isLoadingGroups = false;
      });
    } catch (e) {
      setState(() => _isLoadingGroups = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load owned groups: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Owned Groups",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _isLoadingGroups
                ? const Center(child: CircularProgressIndicator())
                : _ownedGroups.isEmpty
                    ? const Text('No owned groups available')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _ownedGroups.length,
                        itemBuilder: (context, index) {
                          final group = _ownedGroups[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GroupCard(
                              group: group,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupDetailsPage2(group: group),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
