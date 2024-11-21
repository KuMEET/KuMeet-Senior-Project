import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap; // Callback for handling card tap

  const GroupCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when card is tapped
      child: SizedBox(
        width: 150,
        height: 120,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          elevation: 4, // Elevation for shadow effect
          child: Stack(
            children: [
              // Background Image
              Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // Semi-transparent overlay with title
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
