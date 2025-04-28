import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:my_pixels/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtl;
  late TextEditingController _emailCtl;
  String _gender = 'Male';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameCtl = TextEditingController(text: user?.name ?? '');
    _emailCtl = TextEditingController(text: user?.email ?? '');
    _gender = user?.gender ?? 'Male';
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final provider = context.read<UserProvider>();
    // re-use existing password from secure storage if you want
    final newUser = AppUser(
      name: _nameCtl.text.trim(),
      email: _emailCtl.text.trim(),
      gender: _gender,
      password: provider.user?.password ?? '',
    );
    await provider.loginUser(newUser);
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (v) => setState(() => _gender = v!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child:
                  _saving
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
