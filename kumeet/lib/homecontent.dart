import 'package:flutter/material.dart';
import 'package:kumeet/login_page.dart';
import 'group_card.dart';
import 'event.dart';
import 'event_card.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Consistent horizontal padding
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
      final groups = await _groupService.getGroupsByMember(userName!);
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
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      final group = _groups[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Spacing between cards
                        child: Align(
                          alignment: Alignment.centerLeft, // Align GroupCards to the left
                          child: GroupCard(
                            group: group,
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              final event = upcomingEvents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Spacing between cards
                child: Align(
                  alignment: Alignment.centerLeft, // Ensures cards align to the left
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: passedEvents.length,
            itemBuilder: (context, index) {
              final event = passedEvents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Spacing between cards
                child: Align(
                  alignment: Alignment.centerLeft, // Ensures cards align to the left
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
              );
            },
          ),
      ],
    );
  }
}