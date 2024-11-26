import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        backgroundColor: Colors.black, 
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: SignupForm(),
      ),
      backgroundColor: Colors.grey[900], 
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const NameTextField(),
        const SizedBox(height: 16),
        const SurnameTextField(),
        const SizedBox(height: 16),
        const EmailTextField(),
        const SizedBox(height: 16),
        const PhoneTextField(),
        const SizedBox(height: 16),
        const PasswordTextField(),
        const SizedBox(height: 32),
        SignupButton(onPressed: () {
          Navigator.pop(context);
        }),
        const SizedBox(height: 16),
        LoginRedirectButton(onPressed: () {
          Navigator.pop(context);
        }),
      ],
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.person, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class SurnameTextField extends StatelessWidget {
  const SurnameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Surname',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      style: const TextStyle(color: Colors.white),
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

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.phone, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        hintText: 'Optional',
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      keyboardType: TextInputType.phone,
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
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
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

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 1, 107, 95)),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(5.0),
      ),
      child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
    );
  }
}


class LoginRedirectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginRedirectButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 1, 102, 90)),
      ),
      child: const Text("Already have an account? Login"),
    );
  }
}
