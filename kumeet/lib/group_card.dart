import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const GroupCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                imagePath.isEmpty ? 'images/group_image.png' : imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('images/group_image.png', fit: BoxFit.cover);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent black overlay
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensuring text is white for better visibility
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