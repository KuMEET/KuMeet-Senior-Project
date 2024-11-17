import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.teal, // Fresh and modern color
      ),
      body: SingleChildScrollView( // Added to ensure the form is scrollable on small devices
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person), // Icon for name
                border: OutlineInputBorder(),
                fillColor: Colors.teal[50],
                filled: true,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Surname',
                prefixIcon: Icon(Icons.person_outline), // Icon for surname
                border: OutlineInputBorder(),
                fillColor: Colors.teal[50],
                filled: true,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email), // Icon for email
                border: OutlineInputBorder(),
                fillColor: Colors.teal[50],
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number', // Optional field
                prefixIcon: Icon(Icons.phone), // Icon for phone
                border: OutlineInputBorder(),
                hintText: 'Optional',
                fillColor: Colors.teal[50],
                filled: true,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline), // Icon for password
                border: OutlineInputBorder(),
                fillColor: Colors.teal[50],
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to login page after signing up
                Navigator.pop(context);
              },
              child: Text('Sign Up',style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 1, 107, 95)), // Stylish button color
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Return to the login page
                Navigator.pop(context);
              },
              child: Text("Already have an account? Login"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 1, 102, 90)), // Text color to match theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
