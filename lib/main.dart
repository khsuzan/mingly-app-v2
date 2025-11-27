import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/app_router.dart';
import 'package:mingly/src/provider_list.dart';
import 'package:provider/provider.dart';
// Protected screens

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final router = await AppRouter.createRouter();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(GlobalApp(router: router));
}

class GlobalApp extends StatelessWidget {
  final GoRouter router;
  const GlobalApp({super.key, required this.router});
  static const Color primary = Color(0xFFD1B26F); // Gold

  @override
  Widget build(BuildContext context) {
    // Define app colors
    const Color primaryLight = Color(0xFFFCECC2); // Light Gold
    const Color backgroundPrimary = Color(0xFF181818); // Dark background
    const Color lightBackground = Color(0xFF232323); // Lighter dark
    const Color onSurface = Color(0xFFFDFDFD); // Primary text color
    const Color onPrimary = backgroundPrimary; // Text color on primary

    return MultiProvider(
      providers: ProviderList.providers,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp.router(
          title: 'Party Booking App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Gotham',
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: primary,
              onPrimary: onPrimary,
              secondary: primaryLight,
              onSecondary: onPrimary,
              surface: backgroundPrimary,
              onSurface: onSurface,
              primaryContainer: lightBackground,
              error: Colors.red,
              onError: Colors.white,
            ),
            scaffoldBackgroundColor: backgroundPrimary,
            appBarTheme: const AppBarTheme(
              backgroundColor: lightBackground,
              foregroundColor: Colors.white,
              iconTheme: IconThemeData(color: primary),
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          routerConfig: router, // Use GoRouter
        ),
      ),
    );
  }
}
