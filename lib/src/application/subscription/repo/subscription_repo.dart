
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/subscription/model/pakage_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/buy_plan_form.dart';

class SubscriptionRepo {
  Future<List<PakageModel>> getMembershipList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.memberships,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => PakageModel.fromJson(e)).toList();
  }
  Future<UserPackageModel> getUserMembership() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getOrThrow(
      AppUrls.myMembership,
      authToken: preferences.getString("authToken"),
    );
    return UserPackageModel.fromJson(response);
  }

  
  Future<BuyPlanResponse> buyPlan(BuyPlanForm data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postDataOrThrow(
      AppUrls.updagradePlan,
      data.toJson(),
      authToken: preferences.getString("authToken"),
    );
    return BuyPlanResponse.fromJson(response);
  }
  Future<Map<String, dynamic>> cancelMembership() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postData(
      AppUrls.myMembershipCancel,
      {},
      authToken: preferences.getString("authToken"),
    );
    return response;
  }
}
