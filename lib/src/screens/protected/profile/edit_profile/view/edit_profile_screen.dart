import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final profileProvider = context.watch<ProfileProvider>();

    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF1F1E1C),
          appBar: AppBar(
            title: const Text("Edit Profile"),
            backgroundColor: const Color(0xFF2E2D2C),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Image
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    final hasFile = controller.imageFile.value != null;
                    final hasAvatar =
                        controller.profile.value.avatar != null &&
                        controller.profile.value.avatar!.isNotEmpty;
                    if (hasFile) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF3A3937),
                        backgroundImage: FileImage(controller.imageFile.value!),
                      );
                    } else if (hasAvatar) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF3A3937),
                        backgroundImage: null,
                        child: ClipOval(
                          child: Image.network(
                            AppUrls.imageUrlApp +
                                controller.profile.value.avatar!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF3A3937),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 35,
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: 20),

                // Name Input
                TextFormField(
                  controller: controller.nameController,
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
                  controller: controller.phoneController,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFFAE5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    if (controller.isProfileInfoLoading.value) {
                      // Show a read-only input field with a loading indicator
                      return Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            readOnly: true,
                            enabled: true,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              labelStyle: const TextStyle(
                                color: Color(0xFFFAE7E7),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade900,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFFAE5),
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFFAE5),
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFFAE5),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFD1B26F),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    final initialValue =
                        controller.selectedCountry.value ??
                        controller.countryCityData.keys.firstOrNull;

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        menuWidth: 0.8.sw,
                        dropdownColor: Colors.grey.shade900,
                        value: initialValue,
                        hint: const Text(
                          "Country",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                        isExpanded: true,
                        items: controller.countryCityData.keys.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(
                              country,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.onCountryChanged(value);
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Update Profile',
                    onPressed: () {
                      controller.updateProfile(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
