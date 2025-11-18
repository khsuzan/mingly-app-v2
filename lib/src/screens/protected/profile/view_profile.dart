import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Initialize text fields after context is ready
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final profile = context.read<ProfileProvider>().profileModel.data!;
    //   _nameController.text = profile.fullName == ""
    //       ? "N/A"
    //       : profile.fullName.toString();
    //   _phoneController.text = profile.mobile ?? "N/A";
    //   _addressController.text = profile.address ?? "N/A";
    // });
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Example: call your provider update method here
      // final provider = context.read<ProfileProvider>();
      // provider.updateProfile(
      //   name: _nameController.text,
      //   phone: _phoneController.text,
      //   image: _imageFile,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1F1E1C),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF2E2D2C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF3A3937),
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (profileProvider.profileModel.data!.avatar != null
                                ? NetworkImage(
                                    AppUrls.imageUrlNgrok +
                                        profileProvider
                                            .profileModel
                                            .data!
                                            .avatar!,
                                  )
                                : null)
                            as ImageProvider?,
                  child:
                      _imageFile == null &&
                          profileProvider.profileModel.data!.avatar == null
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 35,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Name Input
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: Color(0xFFFAE7E7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 16),

              // Phone Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Color(0xFFFAE7E7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your phone number" : null,
              ),
              const SizedBox(height: 16),

              // Phone Input
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Country',
                  labelStyle: const TextStyle(color: Color(0xFFFAE7E7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFFAE5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your phone number" : null,
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    LoadingDialog.show(context);
                    final status = await profileProvider.updateProfile(
                      name: _nameController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                      image: _imageFile,
                    );
                    LoadingDialog.hide(context);
                    if (status["message"] == "Profile updated successfully.") {
                      CustomSnackbar.show(context, message: status["message"]);
                    } else {
                      CustomSnackbar.show(
                        context,
                        message: "Something try again",
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFAE5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Color(0xFF2E2D2C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
