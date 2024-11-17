import 'package:flutter/material.dart';
import 'event.dart';
import 'eventcard.dart';
import 'eventDetail_page.dart';

class HomeContent extends StatelessWidget {
  final List<Event> calendarEvents;

  const HomeContent({Key? key, required this.calendarEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter for upcoming events based on today's date
    final now = DateTime.now();
    final upcomingEvents = calendarEvents.where((event) => event.date != null && event.date!.isAfter(now)).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your Groups Section
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

          // Divider between sections
          const Divider(thickness: 2, color: Colors.grey),

          // Upcoming Events Section with cards
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Display a message if there are no upcoming events
          if (upcomingEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No upcoming events',
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // Display each upcoming event as a card
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
                        onAddToCalendar: () {
                          // Define any action needed when adding to calendar
                          // In this case, we're viewing details, so it might already be in the calendar
                        },
                        isAdded: true, // Assume it's already added since we're in calendar view
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const GroupCard({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 120,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
