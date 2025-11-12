import 'package:flutter/material.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/home/model/adds_image_model.dart';
import 'package:mingly/src/application/home/model/featured_model.dart';
import 'package:mingly/src/application/home/model/leader_board_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepo {
  

  Future<List<LeaderBoardModel>> getLeaderBoard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.leaderBoard,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => LeaderBoardModel.fromJson(e)).toList();
  }

  
  Future<List<FeaturedModel>> getFeatured() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.featuredSection,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => FeaturedModel.fromJson(e)).toList();
  }

  Future<List<AdsImage>> getAdsImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.getAdsImage,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => AdsImage.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> updagradePlan(Map<String, dynamic> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postData(
      AppUrls.updagradePlan,
      data,
      authToken: preferences.getString("authToken"),
    );
    return response;
  }
}
