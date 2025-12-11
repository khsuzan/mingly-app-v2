import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/subscription/model/buy_plan_form.dart';
import 'package:mingly/src/application/subscription/repo/subscription_repo.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';

import '../../../../application/payment/model/payment_from.dart';
import '../../../../application/subscription/model/pakage_model.dart';

class MembershipController extends GetxController {
  final repo = SubscriptionRepo();

  final membershipList = <PakageModel>[].obs;
  final currentPackage = Rxn<PakageModel>();

  final selectedIndex = 0.obs;

  final isLoading = true.obs;


  @override
  void onReady() {
    super.onReady();
    fetchData();
  }


  void fetchData() {
    fetchMembershipList();
    fetchUserMembershipU();
    // When both lists are populated, sync selectedIndex to currentPackage
    ever(currentPackage, (data) {
      if (membershipList.isNotEmpty && currentPackage.value != null) {
        _syncSelectedIndexToCurrentPackage();
      }
    });

    // Also listen to membershipList changes
    ever(membershipList, (data) {
      if (membershipList.isNotEmpty && currentPackage.value != null) {
        _syncSelectedIndexToCurrentPackage();
      }
    });
  }

  /// Syncs selectedIndex to the index of currentPackage in membershipList
  void _syncSelectedIndexToCurrentPackage() {
    if (currentPackage.value == null) return;

    final index = membershipList.indexWhere(
      (package) => package.id == currentPackage.value!.id,
    );

    if (index != -1) {
      selectedIndex.value = index;
      // carouselController.animateToPage(index);
      debugPrint("Selected index synced to: $index");
    }
  }

  Future<void> fetchMembershipList() async {
    isLoading.value = true;
    try {
      final memberships = await repo.getMembershipList();
      membershipList.value = memberships;
      isLoading.value = false;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error fetching memberships: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> fetchUserMembershipU() async {
    try {
      final response = await repo.getUserMembership();
      currentPackage.value = response.data;
    } catch (e, stack) {
      debugPrint("Error fetching memberships: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> buyMembership(BuildContext context) async {
    final membership = membershipList[selectedIndex.value];

    if (membership.id == null || membership.tier == null) {
      debugPrint("Membership ID or Tier is null");
      return;
    }
    try {
      LoadingDialog.show(context);
      final response = await repo.buyPlan(
        BuyPlanForm(
          membershipId: membership.id!.toString(),
          membershipTier: membership.tier!,
        ),
      );

      if (context.mounted) {
        LoadingDialog.hide(context);
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: response.checkoutUrl,
            fromScreen: FromScreen.membershipPayment,
          ),
        );
      }
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error fetching memberships: $e");
      debugPrintStack(stackTrace: stack);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  Future<void> cancelMembership(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      await repo.cancelMembership();
      if (context.mounted) {
        Future.delayed(Duration(seconds: 5), () {
          if (context.mounted) {
            LoadingDialog.hide(context);
            context.push('/home');
            context.go('/membership');
          }
        });
      }
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error cancel memberships: $e");
      debugPrintStack(stackTrace: stack);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  void onCarouselChanged(int idx, _) {
    selectedIndex.value = idx;
  }
}
