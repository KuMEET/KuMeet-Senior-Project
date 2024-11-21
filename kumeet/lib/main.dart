import 'package:flutter/material.dart';
import 'explore_page.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'event.dart';
import 'homecontent.dart';
import 'group_page.dart';


void main() {
  runApp(const KuMeetApp());
}

class KuMeetApp extends StatelessWidget {
  const KuMeetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Event> calendarEvents = []; // List to store calendar events

  // Function to add an event if it hasn't been added already
  void addEventToCalendar(Event event) {
    if (!calendarEvents.contains(event)) {
      setState(() {
        calendarEvents.add(event);
        calendarEvents.sort((a, b) => a.date!.compareTo(b.date!)); // Sort by date
      });
    }
  }

  // Check if an event is already added to the calendar
  bool isEventAdded(Event event) {
    return calendarEvents.contains(event);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(calendarEvents: calendarEvents), // Pass calendar events to HomeContent
      ExplorePage(
        onAddEventToCalendar: addEventToCalendar, // Pass the calendar callback to ExplorePage
        isEventAdded: isEventAdded, // Check if an event has already been added
      ),
      const GroupPage(), // GroupPage integration
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'images/kumeet_logo.png',
          height: 150,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Groups',
          ),
        ],
      ),
    );
  }
}