import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../application/promo_code/model/promo_code_model.dart';
import '../../../../application/promo_code/repo/promo_code_repo.dart';

class PromoCodeController extends GetxController {
  final PromoCodeRepo promoCodeRepo = PromoCodeRepo();
  final promoCodes = <PromoCodeModel>[].obs;
  final isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchPromoCodes();
  }

  Future<void> fetchPromoCodes() async {
    try {
      isLoading.value = true;
      final response = await promoCodeRepo.getPromoCodes();
      promoCodes.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      debugPrint("Error fetching promo codes: $e");
      debugPrintStack(stackTrace: stack);
      isLoading.value = false;
    }
  }
}
