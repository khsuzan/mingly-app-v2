import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableBookingConfirmationController extends GetxController {
  final inputController = TextEditingController();
  final promoCodeApplied = false.obs;

  void applyPromoCode() {}

  void setPromoCode(String promoCode) {
    inputController.text = promoCode;
  }
}
