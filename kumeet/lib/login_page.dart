import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        backgroundColor: Colors.black, 
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LogoWidget(),
            SizedBox(height: 32),
            LoginForm(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900], 
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset(
          'images/kumeet_logo.png',
          color: Colors.white,
          colorBlendMode: BlendMode.modulate,
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const EmailTextField(),
        const SizedBox(height: 16),
        const PasswordTextField(),
        const SizedBox(height: 32),
        LoginButton(onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        }),
        const SizedBox(height: 16),
        SignUpButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
        ),
      ],
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.email, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[800], 
      ),
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      obscureText: true,
      style: const TextStyle(color: Colors.white),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
<<<<<<< HEAD
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
        padding: WidgetStateProperty.all<EdgeInsets>(
=======
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white, // White text for contrast
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange), // Orange button
        padding: MaterialStateProperty.all<EdgeInsets>(
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
          const EdgeInsets.symmetric(vertical: 12),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
        ),
        elevation: MaterialStateProperty.all<double>(5.0), // Slight elevation for depth
      ),
      child: const Text('Login', style: TextStyle(color: Colors.white)),
    );
  }
}


class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignUpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
<<<<<<< HEAD
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
=======
      child: const Text(
        "Don't have an account? Sign up",
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
>>>>>>> 52f01b7986fdb12aad9c77db1743deaa5d8336a8
      ),
      child: const Text("Don't have an account? Sign up"),
    );
  }
}
