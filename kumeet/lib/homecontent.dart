import 'package:flutter/material.dart';
import 'group_card.dart'; // Import the GroupCard widget
import 'event.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';

class HomeContent extends StatelessWidget {
  final List<Event> calendarEvents;

  const HomeContent({Key? key, required this.calendarEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingEvents = calendarEvents.where((event) => event.date != null && event.date!.isAfter(now)).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const YourGroupsSection(),
          const Divider(thickness: 2, color: Colors.grey),
          UpcomingEventsSection(upcomingEvents: upcomingEvents),
        ],
      ),
    );
  }
}

class YourGroupsSection extends StatelessWidget {
  const YourGroupsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Your Groups',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            GroupCard(
              title: 'Side Project Society',
              imagePath: 'images/group_image1.png',
            ),
            GroupCard(
              title: 'Discover more groups',
              imagePath: 'images/group_image2.png',
            ),
          ],
        ),
      ],
    );
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> upcomingEvents;

  const UpcomingEventsSection({Key? key, required this.upcomingEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
