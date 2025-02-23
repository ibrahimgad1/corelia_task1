import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String bio;
  final String? profilePic;

  const EditProfileScreen(this.name, this.bio, this.profilePic, {super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  String? newProfilePic;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    bioController = TextEditingController(text: widget.bio);
    newProfilePic = widget.profilePic;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        newProfilePic = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color defaultTextColor = themeProvider.isDarkMode
        ? Colors.white
        : themeProvider.isCustomMode
        ? Colors.lightGreen
        : Colors.black;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: themeProvider.isCustomMode
              ? const LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )
              : null,
          color: themeProvider.isCustomMode
              ? null
              : (themeProvider.isDarkMode ? Colors.black : Colors.white),
        ),

        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: newProfilePic != null ? FileImage(File(newProfilePic!)) : null,
                    child: newProfilePic == null
                        ? Icon(Icons.person, size: 60, color: defaultTextColor)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Bio')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'bio': bioController.text,
                  'profilePic': newProfilePic,
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
