import 'package:get/get.dart';

import '../../../../../application/profile/model/profile_model.dart';
import '../../../../../application/profile/repo/profile_repo.dart';

class ViewProfileController extends GetxController {
  // Controller code here
  final ProfileRepo profileRepo = ProfileRepo();

  final profileModel = ProfileModel().obs;


  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    final reseponse = await profileRepo.fetchProfile();
    profileModel.value = reseponse;
  }
}
