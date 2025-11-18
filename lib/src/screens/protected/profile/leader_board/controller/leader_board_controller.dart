import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/home/home_repo.dart';

import '../../../../../application/home/model/leader_board_model.dart';

class LeaderBoardController extends GetxController {
  final homeRepo = HomeRepo();
  final RxList<LeaderBoardModel> topSpendersList = <LeaderBoardModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopSpenders();
  }

  Future<void> fetchTopSpenders() async {
    try {
      isLoading.value = true;
      final response = await homeRepo.getLeaderBoard();
      debugPrint('topSpendersList Response: $response');
      topSpendersList.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      debugPrint('Error fetching topSpendersList events: $e');
      debugPrintStack(stackTrace: stack);
      isLoading.value = false;
    }
  }
}
