import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/subscription/repo/subscription_repo.dart';

import '../../../../application/subscription/model/pakage_model.dart';

class MembershipController extends GetxController{

  final repo = SubscriptionRepo();

  final membershipList = <PakageModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchMembershipDetails();
  }

  Future<void> fetchMembershipDetails() async {
    try {
      final memberships = await repo.getMembershipList();
      membershipList.value = memberships;
    } catch (e, stack) {
      debugPrint("Error fetching memberships: $e");
      debugPrintStack(stackTrace: stack);
    }
  }
}