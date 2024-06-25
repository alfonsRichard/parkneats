import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

final box = GetStorage();
class _ProfileUserPageState extends State<ProfileUserPage> {
  final TextEditingController _usernameController = TextEditingController(text: box.read('fullName'));
  final TextEditingController _phoneController = TextEditingController(text: box.read('phoneNumber'));
  final TextEditingController _emailController = TextEditingController(text: box.read('email'));
  final TextEditingController _passwordController = TextEditingController(text: box.read('password'));

  bool _isEditingUsername = false;
  bool _isEditingPhone = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;
  bool _isPasswordVisible = false;

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile User'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null ? const Icon(Icons.person, size: 50) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _isEditingUsername
                      ? TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          _usernameController.text,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                ),
                IconButton(
                  icon: Icon(_isEditingUsername ? Icons.check : Icons.edit),
                  onPressed: () {
                    setState(() {
                      if (_isEditingUsername) {
                        // Save action can be added here
                      }
                      _isEditingUsername = !_isEditingUsername;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Informasi Akun',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            buildEditableField(
              'Nomor Telephone',
              _phoneController,
              _isEditingPhone,
              () {
                setState(() {
                  _isEditingPhone = true;
                });
              },
              () {
                setState(() {
                  _isEditingPhone = false;
                });
              },
            ),
            const SizedBox(height: 16),
            buildEditableField(
              'Email',
              _emailController,
              _isEditingEmail,
              () {
                setState(() {
                  _isEditingEmail = true;
                });
              },
              () {
                setState(() {
                  _isEditingEmail = false;
                });
              },
            ),
            const SizedBox(height: 16),
            buildEditableField(
              'Password',
              _passwordController,
              _isEditingPassword,
              () {
                setState(() {
                  _isEditingPassword = true;
                });
              },
              () {
                setState(() {
                  _isEditingPassword = false;
                });
              },
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(
    String label,
    TextEditingController controller,
    bool isEditing,
    VoidCallback onEdit,
    VoidCallback onSave, {
    bool isPassword = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              isEditing
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            obscureText: isPassword && !_isPasswordVisible,
                            decoration: const InputDecoration(
                              isDense: true,
                            ),
                          ),
                        ),
                        if (isPassword)
                          IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                      ],
                    )
                  : Text(
                      isPassword ? '********' : controller.text,
                      style: const TextStyle(fontSize: 16),
                    ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: isEditing ? onSave : onEdit,
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
