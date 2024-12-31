import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({
    Key? key,
    required this.group,
    required this.onTap,
  }) : super(key: key);

  void _shareGroup(BuildContext context) {
    Share.share(
      'Check out this group: ${group.name}\nCategory: ${group.categories}\nMembers: ${group.memberCount ?? 0}',
      subject: 'Group: ${group.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 350;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: IntrinsicHeight( // Ensures the card fits its content without extra space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevents extra vertical space
            children: [
              // Top image with member count and share button
              Stack(
                children: [
                  // Group image
                  Container(
                    height: 150,
                    width: cardWidth,
                    child: Image.asset(
                      group.imagePath ?? 'images/group_image1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Member count
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${group.memberCount ?? 0} members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Share button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                        onPressed: () => _shareGroup(context),
                      ),
                    ),
                  ),
                ],
              ),
              // Group details below the image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Prevents extra vertical space
                  children: [
                    // Group name
                    Text(
                      group.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    // Group category
                    Text(
                      group.categories,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
