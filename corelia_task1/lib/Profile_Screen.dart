import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'profile_service.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "ibrahim";
  String bio = "Flutter Developer";
  String? profilePic;
  int? savedTextColorValue;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await ProfileService.loadProfile();
    setState(() {
      name = data['name'];
      bio = data['bio'];
      profilePic = data['profilePic'];
      savedTextColorValue = data['textColor'];
    });
  }

  void _changeTextColor() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Color newColor;

    if (themeProvider.isDarkMode) {
      newColor = (savedTextColorValue != null && Color(savedTextColorValue!) == Colors.white)
          ? Colors.lightGreen
          : Colors.white;
    } else {
      newColor = (savedTextColorValue != null && Color(savedTextColorValue!) == Colors.black)
          ? Colors.lightGreen
          : Colors.black;
    }

    await ProfileService.updateTextColor(newColor.value);

    setState(() {
      savedTextColorValue = newColor.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        Color textColor;
        if (savedTextColorValue != null && themeProvider.isCustomMode) {
          textColor = Color(savedTextColorValue!);
        } else {
          textColor = themeProvider.isDarkMode
              ? Colors.white
              : themeProvider.isCustomMode
              ? Colors.deepPurple.shade900
              : Colors.black;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(icon: const Icon(Icons.brush_outlined), onPressed: _changeTextColor),
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : themeProvider.isCustomMode
                      ? Icons.palette
                      : Icons.light_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme(); // Now using toggleTheme
                },
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: themeProvider.isCustomMode
                  ? const LinearGradient(
                colors: [Colors.blue, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              color: themeProvider.isCustomMode
                  ? null
                  : (themeProvider.isDarkMode ? Colors.black : Colors.white),
            ),

            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePic != null ? FileImage(File(profilePic!)) : null,
                  child: profilePic == null ? const Icon(Icons.person, size: 50) : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "name: $name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 20),
                Text(
                  "bio: $bio",
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen(name, bio, profilePic)),
                    );
                    if (result != null) {
                      ProfileService.updateProfile(result['name'], result['bio'], result['profilePic']);
                      _loadProfile();
                    }
                  },
                  child: const Text("Edit Profile"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
