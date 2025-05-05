import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pixels/core/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
// import '../../themes/app_theme.dart'; // Make sure to import your theme file

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
    // Get the gender theme (default to male)
    final genderTheme = Theme.of(context).extension<GenderTheme>()!;
    final isFemale = genderTheme.isFemale;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: isFemale ? Colors.pink[900] : Colors.blueGrey[900],
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 50.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: genderTheme.accentColor,
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.contains('@') ? null : 'Invalid email',
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: genderTheme.accentColor,
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.length >= 6 ? null : 'Min 6 characters',
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go('/signup'),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: genderTheme.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms),
                  // const SizedBox(height: 24),
                  // _buildDividerWithText('or', context),
                  // const SizedBox(height: 16),
                  // OutlinedButton.icon(
                  //   onPressed: () {}, // Add your Google login logic
                  //   icon: Image.asset(

                  //     height: 24,
                  //   ),
                  //   label: const Text('Continue with Google'),
                  //   style: OutlinedButton.styleFrom(
                  //     side: BorderSide(
                  //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                  //     ),
                  //   ),
                  // ).animate().fadeIn(delay: 350.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //text divider, will use later
  Widget _buildDividerWithText(String text, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
