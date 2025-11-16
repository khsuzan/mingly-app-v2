import 'package:flutter/material.dart';
import 'package:mingly/src/application/bottle/model/bottle_model.dart';
import 'package:mingly/src/application/bottle/repo/bottle_repo.dart';

class BottleProvider extends ChangeNotifier {
  List<BottleModel> bottleList = [];
  getBottleList() async {
    final response = await BottleRepo().getBottle();
    if (response.isNotEmpty) {
      List<BottleModel> data = response;
      for (var e in data) {
        bottleList.add(e);
      }
    }
    notifyListeners();
  }

  String? selectedCategory;
  final List<String> categories = [
    'Coffee',
    'Tea',
    'Juice',
    'Soft Drinks',
    'Smoothies',
  ];

  String getBottleName(int id) {
    return bottleList.firstWhere((e) => e.id == id).brand.toString();
  }

  
}
