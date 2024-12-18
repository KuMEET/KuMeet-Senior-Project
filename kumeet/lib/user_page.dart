import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/event_service.dart';
import 'package:kumeet/eventcard.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/group_card.dart';

// Import your new user detail pages
import 'package:kumeet/user_event_detail_page.dart';
import 'package:kumeet/user_group_detail_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? userName = GlobalState().userName;
  bool isLoading = true;

  List<Event> ownedEvents = [];
  List<Group> ownedGroups = [];

  final EventService eventService = EventService();
  final GroupService groupService = GroupService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch Owned Events
      final events = await eventService.getEventsByAdmin(userName!);

      // Fetch Owned Groups
      final groups = await groupService.getOwnedGroups(userName!);

      setState(() {
        ownedEvents = events;
        ownedGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  void _navigateToUserEventDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserEventDetailPage(eventName: event.title),
      ),
    );
  }

  void _navigateToUserGroupDetail(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserGroupDetailPage(groupName: group.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayUserName = userName ?? "Unknown User";

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayUserName,
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          // Edit button (Currently not functional)
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Username: $displayUserName",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // My Events Section
                  const Text(
                    "My Events",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ownedEvents.isEmpty
                      ? const Text(
                          'You have no owned events.',
                          style: TextStyle(color: Colors.white70),
                        )
                      : Column(
                          children: ownedEvents.map((event) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: EventCard(
                                event: event,
                                onTap: () => _navigateToUserEventDetail(event),
                              ),
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 24),

                  // My Groups Section
                  const Text(
                    "My Groups",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ownedGroups.isEmpty
                      ? const Text(
                          'You have no owned groups.',
                          style: TextStyle(color: Colors.white70),
                        )
                      : Column(
                          children: ownedGroups.map((group) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: GroupCard(
                                title: group.name,
                                imagePath: 'images/group_image.png',
                                onTap: () => _navigateToUserGroupDetail(group),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}
