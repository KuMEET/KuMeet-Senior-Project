import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/event_service.dart';
import 'package:kumeet/eventcard.dart';
import 'package:kumeet/group.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/group_card.dart';
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
      final events = await eventService.getEventsByAdmin(userName!);
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
    final theme = Theme.of(context);
    final displayUserName = userName ?? "Unknown User";

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                        style: theme.textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          // Edit button (Currently not functional)
                        },
                        child: Text(
                          "Edit",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Username: $displayUserName",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // My Events Section
                  Text(
                    "My Events",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ownedEvents.isEmpty
                      ? Text(
                          'You have no owned events.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
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
                  Text(
                    "My Groups",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ownedGroups.isEmpty
                      ? Text(
                          'You have no owned groups.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
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
