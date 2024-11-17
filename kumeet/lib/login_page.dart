import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.deepOrange, // Ensures contrast for white text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 180, // Increased size for better visibility
              child: Center(
                child: Image.asset('images/kumeet_logo.png', // Ensure path is correct
                  color: Colors.orange[800], // Apply a color filter if needed to enhance visibility
                  colorBlendMode: BlendMode.modulate),
              ),
            ),
            SizedBox(height: 32), // Space after logo
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.orange), // Icon color adjusted
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.orange[50], // Light orange fill for text field
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.orange), // Icon color adjusted
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.orange[50], // Consistent fill color with email
              ),
              obscureText: true,
            ),
            SizedBox(height: 32), // Increased space before the button for better spacing
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Login',style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange), // Stylish button color
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 12)), // Thicker button for a better feel
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text("Don't have an account? Sign up"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange), // Stylish text button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
