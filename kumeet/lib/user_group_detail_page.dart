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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pending Requests Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Incoming Requests",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            if (pendingRequests.isEmpty)
              const Text("No pending requests", style: TextStyle(color: Colors.white70))
            else
              for (var user in pendingRequests)
                Card(
                  color: Colors.grey[800],
                  child: ListTile(
                    title: Text(user, style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Approve action (Currently not functional)
                          },
                          child: const Text("Approve", style: TextStyle(color: Colors.greenAccent)),
                        ),
                        TextButton(
                          onPressed: () {
                            // Deny action (Currently not functional)
                          },
                          child: const Text("Deny", style: TextStyle(color: Colors.redAccent)),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Update Group Details", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
