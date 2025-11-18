import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mingly/src/application/point_history/model/point_history_model.dart';
import 'package:mingly/src/application/point_history/repo/point_history_repo.dart';
import 'package:mingly/src/application/profile/model/order_history_model.dart';
import 'package:mingly/src/application/profile/model/profile_model.dart';
import 'package:mingly/src/application/profile/model/voucher_model.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';
import 'package:mingly/src/application/promo_code/model/promo_code_model.dart';
import 'package:mingly/src/application/promo_code/repo/promo_code_repo.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();

  OrderHistoryModel orderHistoryModel = OrderHistoryModel();
  List<VoucherModel> voucherList = [];
  PointHistory pointHistory = PointHistory();
  bool isLoading = false;

  Future<void> getProfile() async {
    final reseponse = await ProfileRepo().fetchProfile();
    profileModel = reseponse;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? address,
    File? image,
  }) async {
    final response = await ProfileRepo().updateProfile({
      "full_name": name,
      "address": address,
      "mobile": phone,
    }, image);
    if (response.isNotEmpty) {
      profileModel.data!.fullName = name;
      profileModel.data!.mobile = phone;
      notifyListeners();
      getProfile();
    } else {
      notifyListeners();
      debugPrint("Failed to update profile");
    }
    return response;
  }

  Future<void> getVoucherList() async {
    isLoading = true;
    notifyListeners();
    final response = await ProfileRepo().getVoucer();
    if (response.isNotEmpty) {
      List<dynamic> data = response;

      for (var e in data) {
        voucherList.add(e);
      }
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }


  Orders? selectedOrder;
  void selectedOrderHistory(String id) {
    selectedOrder = orderHistoryModel.orders!.firstWhere(
      (order) => order.orderNumber == id,
    );
    notifyListeners();
  }

  List<PromoCodeModel> promoCodeList = [];
  Future<void> getPromoCodeList() async {
    final response = await PromoCodeRepo().getPromoCodes();
    if (response.isNotEmpty) {
      promoCodeList = response;
      notifyListeners();
    }
  }

  getPromoValue(String code) {
    for (var promo in promoCodeList) {
      if (promo.code == code) {
        return promo.discountValue;
      }
    }
    return null;
  }
}
