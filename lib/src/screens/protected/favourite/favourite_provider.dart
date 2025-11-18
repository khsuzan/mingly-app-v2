import 'package:flutter/widgets.dart';
import 'package:mingly/src/application/favourite/model/favourite_model.dart';
import 'package:mingly/src/application/favourite/repo/favourite_repo.dart';

class FavouriteProvider extends ChangeNotifier {
  List<FavouriteModel> favouriteList = [];

}
