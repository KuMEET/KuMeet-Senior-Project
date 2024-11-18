import 'package:flutter/material.dart';
import 'package:kumeet/create_group_page.dart';
import 'group_card.dart'; // Import your existing GroupCard widget

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
    final List<Map<String, String>> groups = [
      {'title': 'Sports Club', 'image': 'images/group_image1.png'},
      {'title': 'Book Lovers', 'image': 'images/group_image2.png'},
      {'title': 'Music Band', 'image': 'images/group_image2.png'},
    ];

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GroupCard(
            title: groups[index]['title']!,
            imagePath: groups[index]['image']!,
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
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.add),
    );
  }
}
