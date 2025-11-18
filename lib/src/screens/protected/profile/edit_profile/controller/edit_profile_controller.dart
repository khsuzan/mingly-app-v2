import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mingly/src/application/profile/model/profile_model.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';

import '../../../../../components/custom_loading_dialog.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Rxn<File> imageFile = Rxn<File>(null);
  RxMap<String, dynamic> countryCityData = RxMap<String, dynamic>({});
  RxString selectedCountry = "".obs;

  final profileRepo = ProfileRepo();

  final profile = ProfileModel().obs;

  @override
  void onInit() {
    super.onInit();
    loadCountryCityData();
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
    selectedCountry.value = value ?? "";
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    imageFile.value = null;
    super.onClose();
  }

  void updateProfile(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      final status = await profileRepo.updateProfile();
      LoadingDialog.hide(context);
    } catch (e) {
      LoadingDialog.hide(context);
      debugPrint('Error updating profile: $e');
    }
  }
}
