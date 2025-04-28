import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pixels/core/app_themes.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = 'Male'; // Male by default
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = AppUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        gender: _gender,
        password: '',
      );

      await context.read<UserProvider>().loginUser(user);
      if (mounted) context.go('/gallery');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme based on gender
    final localTheme = AppThemes.lightTheme(_gender);
    final genderTheme = localTheme.extension<GenderTheme>()!;

    return Theme(
      data: localTheme, // Apply the gender-specific theme here
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with logo/icon
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color:
                          genderTheme
                              .softBgColor, // background color based on gender
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _gender == 'Female' ? Icons.female : Icons.male,
                      size: 60,
                      color: genderTheme.accentColor, // icon color
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'My Pixels',
                    style: localTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Personalize your pictures one click a time :)',
                    style: localTheme.textTheme.bodyMedium?.copyWith(
                      color: localTheme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name Field
                    Text(
                      'Full Name',
                      style: localTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            genderTheme
                                .accentColor, // Label color based on gender
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        color: genderTheme.accentColor,
                      ), // Text color for input
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: genderTheme.accentColor,
                        ), // Icon color
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                          color: genderTheme.accentColor.withOpacity(0.3),
                        ), // Placeholder color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor,
                          ),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    Text(
                      'Email Address',
                      style: localTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            genderTheme
                                .accentColor, // Label color based on gender
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                        color: genderTheme.accentColor,
                      ), // Text color for input
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: genderTheme.accentColor,
                        ), // Icon color
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                          color: genderTheme.accentColor.withOpacity(0.3),
                        ), // Placeholder color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (v) => v!.contains('@') ? null : 'Invalid email',
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Text(
                      'Password',
                      style: localTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            genderTheme
                                .accentColor, // Label color based on gender
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: genderTheme.accentColor,
                      ), // Text color for input
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: genderTheme.accentColor,
                        ), // Icon color
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: genderTheme.accentColor.withOpacity(0.3),
                        ), // Placeholder color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor,
                          ),
                        ),
                      ),
                      validator:
                          (v) => v!.length >= 6 ? null : 'Minimum 6 characters',
                    ),
                    const SizedBox(height: 16),

                    // Gender Selector
                    Text(
                      'Gender',
                      style: localTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            genderTheme
                                .accentColor, // Label color based on gender
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      style: TextStyle(
                        color: genderTheme.accentColor,
                      ), // Text color for dropdown selection
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: genderTheme.accentColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: genderTheme.accentColor,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _gender = v!),
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('Create Account'),
                    ),
                    const SizedBox(height: 16),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: localTheme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: localTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: genderTheme.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
