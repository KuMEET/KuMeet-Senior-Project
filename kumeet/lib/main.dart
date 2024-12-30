import 'package:flutter/material.dart';
import 'package:kumeet/event_service.dart';
import 'explore_page.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'event.dart';
import 'homecontent.dart';
import 'group_page.dart';
import 'user_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final globalState = GlobalState();
  await globalState.loadUserName();
  runApp(const KuMeetApp());
}

class KuMeetApp extends StatelessWidget {
  const KuMeetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ------------------- LIGHT THEME -------------------
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF6F3C), // Vibrant Orange
          secondary: Color(0xFF37474F), // Complementary Deep Gray
          background: Color(0xFFF9F9F9), // Light Background
          surface: Color(0xFFFFFFFF), // White for surfaces
          onPrimary: Colors.white,    // Text on Orange
          onSecondary: Colors.white,  // Text on Secondary
          onBackground: Colors.black, // Text on Light Background
          onSurface: Colors.black,    // Text/Icon on Surface
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
          bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,       // Text color
            backgroundColor: Color(0xFFFF6F3C),  // Button color
          ),
        ),

        /// IMPORTANT: Force the AppBar background to white (instead of orange).
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 4,         // Adds a shadow
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.black),
        ),

        /// Give the BottomNavigationBar some elevation too, if you want the shadow
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 4,
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Color(0xFFFF6F3C),
          unselectedItemColor: Colors.black54,
        ),
      ),

      // ------------------- DARK THEME -------------------
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6F3C), // Vibrant Orange
          secondary: Color(0xFF90A4AE),
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          bodySmall: TextStyle(color: Colors.white60, fontSize: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, // Text color
            backgroundColor: Color(0xFFFF6F3C), // Button color
          ),
        ),

        /// Dark mode: no shadow or minimal shadow
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFFFF6F3C),
          unselectedItemColor: Colors.white70,
        ),
      ),

      themeMode: ThemeMode.system, // Use system theme (light/dark) by default
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
      String? userName = GlobalState().userName;
      EventService eventService = EventService();
      final events = await eventService.getEventsByUserMembers(userName!);
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
        calendarEvents.sort((a, b) => a.date!.compareTo(b.date!));
      });
    }
  }

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
    final theme = Theme.of(context);
    final List<Widget> pages = [
      HomeContent(calendarEvents: calendarEvents),
      ExplorePage(
        onAddEventToCalendar: addEventToCalendar,
        isEventAdded: isEventAdded,
      ),
      const GroupPage(),
      const UserPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        // The AppBar background color is now determined by appBarTheme above
        centerTitle: true,
        title: Image.asset(
          'images/kumeet_logo.png',
          height: 100,
          color: theme.brightness == Brightness.light
              ? theme.colorScheme.primary
              : null,
          colorBlendMode: theme.brightness == Brightness.light
              ? BlendMode.modulate
              : null,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: theme.colorScheme.onSurface,
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
