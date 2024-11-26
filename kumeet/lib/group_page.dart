import 'package:flutter/material.dart';
import 'package:kumeet/create_group_page.dart';
import 'group_card.dart';
import 'group_details_page.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(), // Search bar at the top
          ),
          Expanded(
            child: GroupList(), // Scrollable group list
          ),
        ],
      ),
      floatingActionButton: CreateGroupButton(), // Floating action button for group creation
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Groups',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800], 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
      style: const TextStyle(color: Colors.white), 
    );
  }
}

class GroupList extends StatelessWidget {
  const GroupList({super.key});

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
  const CreateGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateGroupPage()),
        );
      },
      backgroundColor: Colors.deepOrange, 
      child: const Icon(
        Icons.add,
        color: Colors.white, 
      ),
    );
  }
}
