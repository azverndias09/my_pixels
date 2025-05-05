import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_pixels/providers/user_provider.dart';
import 'package:my_pixels/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final String _initialName = 'Amey Arsekar';
  final String _initialAge = '28';
  final String _initialBio =
      'Explorer Of Hidden Places, Motorbike Enthusiast, And A Foodie Who Loves Experimenting';
  final String _initialLanguages = 'Hindi, English, Telugu';
  final String _initialLocation = 'Mapusa, Goa';

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _languagesController;
  late TextEditingController _locationController;

  bool _saving = false;
  List<String> _lifestyle = [];
  List<String> _wishToTravel = [];
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _bioController = TextEditingController();
    _languagesController = TextEditingController();
    _locationController = TextEditingController();
    _lifestyle = ['Non-Smoking', 'Not For Me', 'Mountains', 'Beach'];
    _wishToTravel = ['Goa', 'Pune', 'Kerala', 'Meghalaya'];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<UserProvider>();
    // Initialize gender from stored user
    _selectedGender = provider.user?.gender ?? _selectedGender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _languagesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final provider = context.read<UserProvider>();
    final newUser = AppUser(
      name:
          _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : _initialName,
      email: provider.user?.email ?? '',
      gender: _selectedGender,
      password: provider.user?.password ?? '',
    );
    await provider.loginUser(newUser);
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Roboto styles
    final labelStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    final greyHint = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade400,
    );
    final fieldText = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade800,
    );
    final chipStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    final buttonStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    // Pill chip theme
    final pillTheme = ChipThemeData(
      backgroundColor: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade400)),
      labelStyle: chipStyle,
      deleteIconColor: Colors.grey.shade600,
      selectedColor: const Color(0xFFDCEEFB),
      secondarySelectedColor: const Color(0xFFDCEEFB),
      brightness: Brightness.light,
    );

    InputDecoration fieldDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: greyHint,
      isDense: true,
      filled: false,
      contentPadding: const EdgeInsets.only(bottom: 8),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black87),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          sectionHeader('Name', labelStyle),
          TextField(
            controller: _nameController,
            style: fieldText,
            decoration: fieldDecoration(_initialName),
          ),
          const Divider(height: 5),

          sectionHeader('Gender', labelStyle),
          ChipTheme(
            data: pillTheme,
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.male, size: 18),
                      const SizedBox(width: 6),
                      Text('Male', style: chipStyle),
                    ],
                  ),
                  selected: _selectedGender == 'Male',
                  onSelected: (_) => setState(() => _selectedGender = 'Male'),
                ),
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.female, size: 18),
                      const SizedBox(width: 6),
                      Text('Female', style: chipStyle),
                    ],
                  ),
                  selected: _selectedGender == 'Female',
                  onSelected: (_) => setState(() => _selectedGender = 'Female'),
                ),
              ],
            ),
          ),
          const Divider(height: 5),

          sectionHeader('Age', labelStyle),
          TextField(
            controller: _ageController,
            style: fieldText,
            keyboardType: TextInputType.number,
            decoration: fieldDecoration(_initialAge),
          ),
          const Divider(height: 5),

          sectionHeader('Lifestyle', labelStyle),
          ChipTheme(
            data: pillTheme,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _lifestyle.map((label) {
                    IconData icon;
                    switch (label) {
                      case 'Non-Smoking':
                        icon = Icons.smoke_free;
                        break;
                      case 'Not For Me':
                        icon = Icons.no_drinks;
                        break;
                      case 'Mountains':
                        icon = Icons.terrain;
                        break;
                      case 'Beach':
                        icon = Icons.beach_access;
                        break;
                      default:
                        icon = Icons.label;
                    }
                    return Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 18, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          Text(label, style: chipStyle),
                        ],
                      ),
                      deleteIcon: const Icon(Icons.close, size: 20),
                      onDeleted: () => setState(() => _lifestyle.remove(label)),
                    );
                  }).toList(),
            ),
          ),
          const Divider(height: 5),

          sectionHeader('My Location', labelStyle),
          TextField(
            controller: _locationController,
            style: fieldText,
            decoration: fieldDecoration(_initialLocation),
          ),
          const Divider(height: 5),

          sectionHeader('Add Bio', labelStyle),
          TextField(
            controller: _bioController,
            style: fieldText,
            maxLines: 2,
            decoration: fieldDecoration(_initialBio),
          ),
          const Divider(height: 0),

          sectionHeader('Languages spoken', labelStyle),
          TextField(
            controller: _languagesController,
            style: fieldText,
            decoration: fieldDecoration(_initialLanguages),
          ),
          const Divider(height: 5),

          sectionHeader('Wish to travel', labelStyle),
          ChipTheme(
            data: pillTheme,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _wishToTravel.map((label) {
                    return Chip(
                      label: Text(label, style: chipStyle),
                      deleteIcon: const Icon(Icons.close, size: 24),
                      onDeleted:
                          () => setState(() => _wishToTravel.remove(label)),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  _saving
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text('SAVE', style: buttonStyle),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget sectionHeader(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(text, style: style),
    );
  }
}
