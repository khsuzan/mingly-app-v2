import 'package:get/get.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';

import '../../../../application/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  final isProfileInfoLoading = false.obs;
  final profile = PersonalInformation().obs;

  final ProfileRepo profileRepo = ProfileRepo();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isProfileInfoLoading.value = true;
      final response = await profileRepo.fetchProfile();
      profile.value = response.data!;
    } catch (e) {
      // Get.snackbar('Error', 'Failed to load profile: $e',
      //     snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProfileInfoLoading.value = false;
    }
  }
}
