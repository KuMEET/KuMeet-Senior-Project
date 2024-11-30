import 'package:flutter/material.dart';
import 'user_service.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); // New username field
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userData = {
        'userName': _usernameController.text,
        'name': _nameController.text,
        'surname': _surnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        final response = await _userService.signup(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${response['name']}!')),
        );

        Navigator.pop(context); // Navigate back to login
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo or Title
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[200],
                    ),
                  ),
                ),
              ),

              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: _buildInputDecoration('Username', Icons.account_circle),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your username' : null,
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Name', Icons.person),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),

              // Surname Field
              TextFormField(
                controller: _surnameController,
                decoration: _buildInputDecoration('Surname', Icons.person_outline),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your surname' : null,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration('Email', Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: _buildInputDecoration('Password', Icons.lock),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 32),

              // Signup Button
              ElevatedButton(
                onPressed: _isLoading ? null : _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: 16),

              // Login Redirect Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal[200],
                ),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent InputDecoration
  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: const TextStyle(color: Colors.white),
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
        const UsernameTextField(),
        const SizedBox(height: 16),
        const NameTextField(),
        const SizedBox(height: 16),
        const SurnameTextField(),
        const SizedBox(height: 16),
        const EmailTextField(),
        const SizedBox(height: 16),
        const PasswordTextField(),
        const SizedBox(height: 32),
        SignupButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 16),
        LoginRedirectButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.account_circle, color: Colors.white),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 1, 107, 95),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
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
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 1, 102, 90),
      ),
      child: const Text("Already have an account? Login"),
    );
  }
}