import 'package:mingly/src/screens/auth/auth_provider.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/home_screen/home_proivder.dart';
import 'package:mingly/src/screens/protected/my_menu/bottle_provider.dart';
import 'package:mingly/src/screens/protected/profile/profile_provider.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/venue_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderList {
  static List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(
      create: (_) => VenueProvider()
    ),
    ChangeNotifierProvider(
      create: (_) => EventsProvider()
    ),
    ChangeNotifierProvider(create: (_) => BottleProvider()..getBottleList()),
    ChangeNotifierProvider(
      create: (_) => ProfileProvider()
    ),
    ChangeNotifierProvider(
      create: (_) => HomeProivder()
        ..getCurrentLocationName()
        ..getLeaderBoardlist()
        ..getAdsImagelist()
        ..getPackagelist(),
    ),
  ];
}
