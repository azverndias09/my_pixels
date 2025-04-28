import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthProvider>().login(
        _emailController.text,
        _passwordController.text,
      );
      context.go('/gallery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) => value!.contains('@') ? null : 'Invalid email',
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator:
                    (value) => value!.length >= 6 ? null : 'Min 6 characters',
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ).animate().fadeIn(delay: 300.ms),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text('Create Account'),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
