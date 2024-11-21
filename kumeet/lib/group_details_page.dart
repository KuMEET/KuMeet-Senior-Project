import 'package:flutter/material.dart';

class GroupDetailsPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final int capacity;
  final int occupancy;

  const GroupDetailsPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.capacity,
    required this.occupancy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900], 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      backgroundColor: Colors.grey[900], 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GroupImage(imagePath: imagePath),
            const SizedBox(height: 16),
            GroupInfo(title: title, capacity: capacity, occupancy: occupancy),
            const SizedBox(height: 24),
            JoinButton(title: title),
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
        color: Colors.black.withOpacity(0.6), 
        colorBlendMode: BlendMode.darken, 
      ),
    );
  }
}

class GroupInfo extends StatelessWidget {
  final String title;
  final int capacity;
  final int occupancy;

  const GroupInfo({
    super.key,
    required this.title,
    required this.capacity,
    required this.occupancy,
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
            color: Colors.white, // Bright title text
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Capacity: $capacity',
          style: const TextStyle(fontSize: 18, color: Colors.white70), 
        ),
        Text(
          'Occupancy: $occupancy',
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
    );
  }
}

class JoinButton extends StatelessWidget {
  final String title;

  const JoinButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Join request sent to $title!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.deepOrange, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), 
        ),
      ),
      child: const Text(
        'Join',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
