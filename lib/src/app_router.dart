import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/screens/auth/email_verification_screen/email_verification_screen.dart';
import 'package:mingly/src/screens/auth/login_screen/login_screen.dart';
import 'package:mingly/src/screens/auth/otp_verification_screen/otp_verfication_forgot_password.dart';
import 'package:mingly/src/screens/auth/otp_verification_screen/otp_verification_screen.dart';
import 'package:mingly/src/screens/auth/password_reset_screen/password_reset_screen.dart';
import 'package:mingly/src/screens/auth/signup_screen/signup_screen.dart';
import 'package:mingly/src/screens/auth/welcome_screen/welcome_screen.dart'
    show WelcomeScreen;
import 'package:mingly/src/screens/protected/berverages/beverages_screen.dart';
import 'package:mingly/src/screens/protected/booking_confirmation_screen/booking_confirmation_screen.dart';
import 'package:mingly/src/screens/protected/booking_confirmation_screen/table_booking_confirmation_screen.dart';
import 'package:mingly/src/screens/protected/booking_summary/booking_summary.dart';
import 'package:mingly/src/screens/protected/event_detail_screen/event_detail_screen.dart';
import 'package:mingly/src/screens/protected/event_detail_screen/event_details_screen_one.dart';
import 'package:mingly/src/screens/protected/event_list_screen/event_list_screen.dart';
import 'package:mingly/src/screens/protected/favourite/favourite_screen.dart';
import 'package:mingly/src/screens/protected/food_menu_screen/food_menu_screen.dart';
import 'package:mingly/src/screens/protected/home_screen/ai_chat.dart';
import 'package:mingly/src/screens/protected/home_screen/home_screen.dart';
import 'package:mingly/src/screens/protected/landing_page.dart/landing_page.dart';
import 'package:mingly/src/screens/protected/membership_screen/membership_screen.dart';
import 'package:mingly/src/screens/protected/my_bottles/my_bottles_history.dart';
import 'package:mingly/src/screens/protected/my_bottles/my_bottles_screen.dart';
import 'package:mingly/src/screens/protected/my_reservation_screen/my_reservation_screen.dart';
import 'package:mingly/src/screens/protected/notification_screen/notification_screen.dart';
import 'package:mingly/src/screens/protected/payment/payment_screen.dart';
import 'package:mingly/src/screens/protected/payment/payment_table.dart';
import 'package:mingly/src/screens/protected/personal_info_screen/personal_info_screen.dart';
import 'package:mingly/src/screens/protected/profile_screen/edit_profile.dart';
import 'package:mingly/src/screens/protected/profile_screen/leader_board.dart';
import 'package:mingly/src/screens/protected/profile_screen/order_history.dart';
import 'package:mingly/src/screens/protected/profile_screen/order_history_details.dart';
import 'package:mingly/src/screens/protected/profile_screen/point_history.dart';
import 'package:mingly/src/screens/protected/profile_screen/profile_screen.dart';
import 'package:mingly/src/screens/protected/profile_screen/promo_code_screen.dart';
import 'package:mingly/src/screens/protected/profile_screen/view_profile_screen.dart';
import 'package:mingly/src/screens/protected/profile_screen/voucher_list.dart';
import 'package:mingly/src/screens/protected/select_country_screen/select_country_screen.dart';
import 'package:mingly/src/screens/protected/select_payment_screen/select_payment_screen.dart';
import 'package:mingly/src/screens/protected/table_booking_screen/table_booking_screen.dart';
import 'package:mingly/src/screens/protected/ticket_booking_screen/ticket_booking_screen.dart';
import 'package:mingly/src/screens/protected/venue_detail_screen/view/venue_detail_screen.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/view/venue_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/venues/model/venues_model.dart';

class AppRouter {
  static Future<GoRouter> createRouter() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final initial = (token != null && token.isNotEmpty) ? "/home" : "/welcome";

    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: initial,
      routes: [
        // Auth routes
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/password-reset',
          builder: (context, state) => const PasswordResetScreen(),
        ),
        GoRoute(
          path: '/otp-verification',
          builder: (context, state) => const OTPVerificationScreen(),
        ),
        GoRoute(
          path: '/otp-verification-forgot-password',
          builder: (context, state) => const OtpVerficationForgotPassword(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/email-verification',
          builder: (context, state) => const EmailVerificationScreen(),
        ),
        GoRoute(
          path: '/event-list',
          builder: (context, state) => const EventListScreen(),
        ),
        GoRoute(
          path: '/venue-list',
          builder: (context, state) => const VenueListScreen(),
        ),
        GoRoute(
          path: '/ticket-booking',
          builder: (context, state) => const TicketBookingScreen(),
        ),
        GoRoute(
          path: '/venue-detail',
          builder: (context, state) {
            final venue =
                state.extra as VenuesModel;
            return VenueDetailScreen(venue: venue);
          },
        ),
        GoRoute(
          path: '/table-booking',
          builder: (context, state) => const TableBookingScreen(),
        ),
        GoRoute(
          path: '/select-country',
          builder: (context, state) => const SelectCountryScreen(),
        ),
        GoRoute(
          path: '/select-payment',
          builder: (context, state) => const SelectPaymentScreen(),
        ),
        GoRoute(
          path: '/my-bottles',
          builder: (context, state) => const MyBottlesScreen(),
        ),
        GoRoute(
          path: '/my-bottles-history',
          builder: (context, state) => const MyBottlesHistoryScreen(),
        ),
        GoRoute(
          path: '/personal-info',
          builder: (context, state) => const PersonalInfoScreen(),
        ),
        GoRoute(
          path: '/membership',
          builder: (context, state) => const MembershipScreen(),
        ),
        GoRoute(
          path: '/food-menu',
          builder: (context, state) => const FoodMenuScreen(),
        ),
        GoRoute(
          path: '/event-detail',
          builder: (context, state) {
            final event =
                state.extra as EventsModel; // 👈 cast to your event model type
            return EventDetailScreen(model: event);
          },
        ),

        GoRoute(
          path: '/event-detail-one',
          builder: (context, state) => const EventDetailsScreenOne(),
        ),
        GoRoute(
          path: '/beverages',
          builder: (context, state) => const BeveragesScreen(),
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) => PaymentMethodScreen(),
        ),
        GoRoute(
          path: '/booking-confirmation',
          builder: (context, state) => BookingConfirmationScreen(),
        ),
        GoRoute(
          path: '/table-booking-confirmation',
          builder: (context, state) => TableBookingConfirmationScreen(),
        ),
        GoRoute(
          path: '/payment-table',
          builder: (context, state) => PaymentTable(),
        ),
        GoRoute(
          path: '/booking-summary',
          builder: (context, state) => BookingSummary(),
        ),
        GoRoute(
          path: '/view-profile',
          builder: (context, state) => ViewProfileScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => EditProfileScreen(),
        ),
        GoRoute(
          path: '/leaderboard',
          builder: (context, state) => LeaderBoard(),
        ),
        GoRoute(
          path: '/voucher-list',
          builder: (context, state) => VoucherListScreen(),
        ),
        GoRoute(path: '/ai-chat', builder: (context, state) => AiChatScreen()),
        GoRoute(
          path: '/point-history',
          builder: (context, state) => PointsHistoryScreen(),
        ),
        GoRoute(
          path: '/order-history',
          builder: (context, state) => OrderHistoryPage(),
        ),
        GoRoute(
          path: '/order-history-details',
          builder: (context, state) => OrderDetailsPage(),
        ),
        GoRoute(
          path: '/promo-code',
          builder: (context, state) => PromoListScreen(),
        ),
        // Shell routing for protected pages
        ShellRoute(
          builder: (context, state, child) => LandingPage(child: child),
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/my-reservation',
              builder: (context, state) => const MyReservationScreen(),
            ),
            GoRoute(
              path: '/my-favorites',
              builder: (context, state) => const FavouriteScreen(),
            ),
            GoRoute(
              path: '/notification',
              builder: (context, state) => const NotificationScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

class TTableBookingConfirmationScreen {}
