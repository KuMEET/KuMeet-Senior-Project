import 'package:flutter/material.dart';
import 'package:kumeet/user_service.dart';
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
  List<Event> calendarEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCalendarEvents();
  }
    Future<void> _initializeCalendarEvents() async {
    try {
      String userName = GlobalState().userName ?? "default";
      UserService userService = UserService();
      final events = await userService.getUserEvents(userName);
      setState(() {
        calendarEvents = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error initializing calendar events: $e');
    }
  }
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
      HomeContent(calendarEvents: calendarEvents), 
      ExplorePage(
        onAddEventToCalendar: addEventToCalendar, 
        isEventAdded: isEventAdded, 
      ),
      const GroupPage(), 
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'images/kumeet_logo.png',
          height: 100,
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
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey[400], 
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
        type: BottomNavigationBarType.fixed, // Ensure labels are always visible
      ),
    );
  }
}

