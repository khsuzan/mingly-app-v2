import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingly/src/application/profile/model/profile_model.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';
import 'package:mingly/src/components/custom_snackbar.dart';

import '../../../../../components/custom_loading_dialog.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  Rxn<File> imageFile = Rxn<File>(null);
  RxMap<String, dynamic> countryCityData = RxMap<String, dynamic>({});
  RxnString selectedCountry = RxnString(null);
  final isProfileInfoLoading = false.obs;

  final profileRepo = ProfileRepo();

  final profile = PersonalInformation().obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    loadCountryCityData();
  }

  Future<void> fetchProfile() async {
    try {
      isProfileInfoLoading.value = true;
      final response = await profileRepo.fetchProfile();
      profile.value = response.data!;
      selectedCountry.value = response.data?.address;
      nameController.text = response.data?.fullName ?? '';
      phoneController.text = response.data?.mobile ?? '';
      addressController.text = response.data?.address ?? '';
    } catch (e) {
      // Get.snackbar('Error', 'Failed to load profile: $e',
      //     snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProfileInfoLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> loadCountryCityData() async {
    final jsonString = await rootBundle.loadString(
      'lib/assets/country_city.json',
    );
    final data = json.decode(jsonString) as Map<String, dynamic>;
    countryCityData.value = data;
  }

  void onCountryChanged(String? value) {
    addressController.text = value ?? '';
    selectedCountry.value = value;
  }

  void updateProfile(BuildContext context) async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    if (name.isEmpty && phone.isEmpty && address.isEmpty) {
      CustomSnackbar.show(
        context,
        message: 'Please fill out at least one field',
      );
      return;
    }
    try {
      LoadingDialog.show(context);
      final Map<String, dynamic> data = {};
      if (name.isNotEmpty) data["full_name"] = name;
      if (address.isNotEmpty) data["address"] = address;
      if (phone.isNotEmpty) data["mobile"] = phone;
      final status = await profileRepo.updateProfile(data, imageFile.value);
      if (context.mounted) {
        LoadingDialog.hide(context);
        CustomSnackbar.show(context, message: 'Profile updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      debugPrint('Error updating profile: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    imageFile.value = null;
    super.onClose();
  }
}
