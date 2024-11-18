import 'package:flutter/material.dart';
import 'package:kumeet/create_group_page.dart';
import 'group_card.dart';
import 'group_details_page.dart'; 

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(), // Search bar at the top
          ),
          Expanded(
            child: GroupList(), // Scrollable group list
          ),
        ],
      ),
      floatingActionButton: const CreateGroupButton(), // Floating action button for group creation
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Groups',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class GroupList extends StatelessWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy group data for now
    final List<Map<String, dynamic>> groups = [
      {
        'title': 'Sports Club',
        'image': 'images/group_image1.png',
        'capacity': 50,
        'occupancy': 35,
      },
      {
        'title': 'Book Lovers',
        'image': 'images/group_image2.png',
        'capacity': 30,
        'occupancy': 28,
      },
      {
        'title': 'Music Band',
        'image': 'images/group_image2.png',
        'capacity': 20,
        'occupancy': 10,
      },
    ];

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GroupCard(
            title: group['title']!,
            imagePath: group['image']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsPage(
                    imagePath: group['image']!,
                    title: group['title']!,
                    capacity: group['capacity']!,
                    occupancy: group['occupancy']!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CreateGroupButton extends StatelessWidget {
  const CreateGroupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateGroupPage()),
        );
      },
      backgroundColor: const Color.fromARGB(255, 255, 120, 53),
      child: const Icon(Icons.add, color: Colors.white,),
    );
  }
}
