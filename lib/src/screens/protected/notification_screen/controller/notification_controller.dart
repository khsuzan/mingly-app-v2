import 'package:get/get.dart';

import '../../../../application/notification/model/notification_model.dart';
import '../../../../application/notification/repo/notification_repo.dart';

class NotificationController extends GetxController {

  RxList<Notifications> notifications = <Notifications>[].obs;
  final repo = NotificationRepo();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotificationData();
  }

  Future<void> getNotificationData() async {
    try {
      isLoading.value = true;
      final response = await repo.getNotifcation();
      notifications.value = response;
    } catch (e) {
      // Handle error if necessary
    } finally {
      isLoading.value = false;
    }
  }
}
