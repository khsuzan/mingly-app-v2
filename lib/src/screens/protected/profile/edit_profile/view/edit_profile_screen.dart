import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF3A3937),
                      backgroundImage: controller.imageFile.value != null
                          ? FileImage(controller.imageFile.value!)
                          : (controller.profile.value.avatar != null
                                    ? NetworkImage(
                                        AppUrls.imageUrlApp +
                                            controller.profile.value.avatar!,
                                      )
                                    : null)
                                as ImageProvider?,
                      child:
                          controller.imageFile.value == null &&
                              controller.profile.value.avatar == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 35,
                            )
                          : null,
                    );
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
                      return const Center(child: CircularProgressIndicator());
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
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateProfile(context);
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
        );
      },
    );
  }
}
