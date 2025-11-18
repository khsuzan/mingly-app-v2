import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../application/point_history/model/point_history_model.dart';
import '../../../../../application/point_history/repo/point_history_repo.dart';

class PointHistoryController extends GetxController {
  final pointRepo = PointHistoryRepo();
  final RxBool isLoading = false.obs;
  final Rx<PointHistory> pointHistory = PointHistory().obs;
  @override
  void onInit() {
    super.onInit();
    getPointHistory();
  }

  Future<void> getPointHistory() async {
    try {
      isLoading.value = true;
      final response = await pointRepo.getPointHistory();
      debugPrint('Point History Response: $response');
      pointHistory.value = response;
    } catch (e, stack) {
      debugPrint('Error fetching Point History: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }
}
