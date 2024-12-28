import 'package:flutter/material.dart';
import 'package:kumeet/groupEventPage2.dart';
import 'group.dart';

class GroupDetailsPage2 extends StatefulWidget {
  final Group group;

  const GroupDetailsPage2({super.key, required this.group});

  @override
  _GroupDetailsPage2State createState() => _GroupDetailsPage2State();
}

class _GroupDetailsPage2State extends State<GroupDetailsPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GroupImage(imagePath: 'images/group_image1.png'),
            const SizedBox(height: 16),
            GroupInfo(
              title: widget.group.name,
              capacity: widget.group.capacity,
              category: widget.group.categories,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupEventsPage2(group: widget.group),
                  ),
                );
              },
              child: const Text('See Events'),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupImage extends StatelessWidget {
  final String imagePath;

  const GroupImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }
}

class GroupInfo extends StatelessWidget {
  final String title;
  final int capacity;
  final String category;

  const GroupInfo({
    super.key,
    required this.title,
    required this.capacity,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Capacity: $capacity',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          'Category: $category',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
