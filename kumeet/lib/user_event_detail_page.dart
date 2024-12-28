import 'package:flutter/material.dart';

class UserEventDetailPage extends StatefulWidget {
  final String eventName;

  const UserEventDetailPage({Key? key, required this.eventName}) : super(key: key);

  @override
  State<UserEventDetailPage> createState() => _UserEventDetailPageState();
}

class _UserEventDetailPageState extends State<UserEventDetailPage> {
  // Sample incoming requests (In the future, load from backend)
  final List<String> pendingRequests = ["user1", "user2", "user3"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
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
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              )
            else
              ...pendingRequests.map(
                (user) => Card(
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
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Deny action (Currently not functional)
                          },
                          child: Text(
                            "Deny",
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // Update Event Details Button
            ElevatedButton(
              onPressed: () {
                // Update event details (Currently not functional)
              },
              child: const Text("Update Event Details"),
            ),
          ],
        ),
      ),
    );
  }
}
