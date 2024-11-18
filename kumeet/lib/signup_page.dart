import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.teal,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

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
  const NameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: const Icon(Icons.person),
        border: const OutlineInputBorder(),
        fillColor: Colors.teal[50],
        filled: true,
      ),
    );
  }
}

class SurnameTextField extends StatelessWidget {
  const SurnameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Surname',
        prefixIcon: const Icon(Icons.person_outline),
        border: const OutlineInputBorder(),
        fillColor: Colors.teal[50],
        filled: true,
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: const OutlineInputBorder(),
        fillColor: Colors.teal[50],
        filled: true,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone),
        border: const OutlineInputBorder(),
        hintText: 'Optional',
        fillColor: Colors.teal[50],
        filled: true,
      ),
      keyboardType: TextInputType.phone,
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        fillColor: Colors.teal[50],
        filled: true,
      ),
      obscureText: true,
    );
  }
}

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignupButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 1, 107, 95)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class LoginRedirectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginRedirectButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text("Already have an account? Login"),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 1, 102, 90)),
      ),
    );
  }
}
