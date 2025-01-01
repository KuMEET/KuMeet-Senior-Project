import 'package:flutter/material.dart';

class UserGroupDetailPage extends StatefulWidget {
  final String groupName;

  const UserGroupDetailPage({Key? key, required this.groupName}) : super(key: key);

  @override
  State<UserGroupDetailPage> createState() => _UserGroupDetailPageState();
}

class _UserGroupDetailPageState extends State<UserGroupDetailPage> {
  // Sample incoming requests (In the future, load from backend)
  final List<String> pendingRequests = ["userA", "userB"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pending Requests Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Incoming Requests",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            if (pendingRequests.isEmpty)
              Text(
                "No pending requests",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            else
              for (var user in pendingRequests)
                Card(
                  child: ListTile(
                    title: Text(user, style: theme.textTheme.bodyMedium),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Approve action (Currently not functional)
                          },
                          child: Text(
                            "Approve",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Deny action (Currently not functional)
                          },
                          child: Text(
                            "Deny",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            const Spacer(),

            // Update Group Details Button
            ElevatedButton(
              onPressed: () {
                // Update group details (Currently not functional)
              },
              child: const Text("Update Group Details"),
            ),
          ],
        ),
      ),
    );
  }
}
