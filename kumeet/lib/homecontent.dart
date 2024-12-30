import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
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
    final passedEvents = calendarEvents
        .where((event) => event.date != null && event.date!.isBefore(now))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YourGroupsSection(),
              const Divider(thickness: 1.5),
              UpcomingEventsSection(upcomingEvents: upcomingEvents),
              const Divider(thickness: 1.5),
              PassedEventsSection(passedEvents: passedEvents),
            ],
          ),
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
  String? userName = GlobalState().userName;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      final groups = await _groupService.getGroupsByUser(userName!);
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
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Joined Groups',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _groups.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No groups available'),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      final group = _groups[index];
                      return GroupCard(
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
                      );
                    },
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
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        if (upcomingEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No upcoming events'),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = upcomingEvents[index];
              return EventCard(
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
              );
            },
          ),
      ],
    );
  }
}

class PassedEventsSection extends StatelessWidget {
  final List<Event> passedEvents;

  const PassedEventsSection({super.key, required this.passedEvents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Passed Events',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        if (passedEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No passed events'),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: passedEvents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = passedEvents[index];
              return EventCard(
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
              );
            },
          ),
      ],
    );
  }
}
