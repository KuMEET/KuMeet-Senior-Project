import 'package:flutter/material.dart';
import 'group_card.dart';
import 'event.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';
import 'group_details_page.dart';
import 'group_service.dart';
import 'group.dart';

class HomeContent extends StatelessWidget {
  final List<Event> calendarEvents;

  const HomeContent({super.key, required this.calendarEvents});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingEvents = calendarEvents
        .where((event) => event.date != null && event.date!.isAfter(now))
        .toList();

    return Container(
      color: Colors.grey[900],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YourGroupsSection(), // Displays dynamic groups
            const Divider(thickness: 0.5, color: Colors.grey),
            UpcomingEventsSection(upcomingEvents: upcomingEvents),
          ],
        ),
      ),
    );
  }
}

class YourGroupsSection extends StatefulWidget {
  const YourGroupsSection({super.key});

  @override
  _YourGroupsSectionState createState() => _YourGroupsSectionState();
}

class _YourGroupsSectionState extends State<YourGroupsSection> {
  final GroupService _groupService = GroupService();
  List<Group> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      final groups = await _groupService.getGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch groups: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Your Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _groups.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No groups available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _groups.map((group) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GroupCard(
                            title: group.name,
                            imagePath: 'images/group_image.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupDetailsPage(group: group),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
      ],
    );
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> upcomingEvents;

  const UpcomingEventsSection({super.key, required this.upcomingEvents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (upcomingEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No upcoming events',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          for (var event in upcomingEvents)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: EventCard(
                event: event,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailPage(
                        event: event,
                        onAddToCalendar: () {},
                        isAdded: true,
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
