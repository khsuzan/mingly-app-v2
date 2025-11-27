import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/screens/auth/email_verification_screen/email_verification_screen.dart';
import 'package:mingly/src/screens/auth/login_screen/view/login_screen.dart';
import 'package:mingly/src/screens/auth/otp_verification_forgot/otp_verfication_forgot_password.dart';
import 'package:mingly/src/screens/auth/otp_verification_screen/otp_verification_screen.dart';
import 'package:mingly/src/screens/auth/password_reset_screen/password_reset_screen.dart';
import 'package:mingly/src/screens/auth/signup_screen/view/signup_screen.dart';
import 'package:mingly/src/screens/auth/welcome_screen/views/welcome_screen.dart'
    show WelcomeScreen;
import 'package:mingly/src/screens/protected/berverages/view/beverages_screen.dart';
import 'package:mingly/src/screens/protected/booking_confirmation_screen/table_booking/view/table_booking_confirmation_screen.dart';
import 'package:mingly/src/screens/protected/booking_confirmation_screen/ticket_booking/view/booking_confirmation_screen.dart';
import 'package:mingly/src/screens/protected/booking_summary/booking_summary.dart';
import 'package:mingly/src/screens/protected/event_detail_screen/event_details_screen_one.dart';
import 'package:mingly/src/screens/protected/event_detail_screen/view/event_detail_screen.dart';
import 'package:mingly/src/screens/protected/event_list_screen/view/event_list_screen.dart';
import 'package:mingly/src/screens/protected/favourite/view/favourite_screen.dart';
import 'package:mingly/src/screens/protected/home_screen/ai_chat.dart';
import 'package:mingly/src/screens/protected/home_screen/view/home_screen.dart';
import 'package:mingly/src/screens/protected/landing_page.dart/landing_page.dart';
import 'package:mingly/src/screens/protected/membership_screen/membership_screen.dart';
import 'package:mingly/src/screens/protected/my_booking/view/my_booking_screen.dart';
import 'package:mingly/src/screens/protected/my_menu/view/my_menu_screen.dart';
import 'package:mingly/src/screens/protected/notification_screen/view/notification_screen.dart';
import 'package:mingly/src/screens/protected/payment/payment_screen.dart';
import 'package:mingly/src/screens/protected/payment/payment_table.dart';
import 'package:mingly/src/screens/protected/personal_info_screen/personal_info_screen.dart';
import 'package:mingly/src/screens/protected/profile/edit_profile/view/edit_profile_screen.dart';
import 'package:mingly/src/screens/protected/profile/leader_board/view/leader_board_screen.dart';
import 'package:mingly/src/screens/protected/profile/order_history_details.dart';
import 'package:mingly/src/screens/protected/profile/points_history/view/point_history_screen.dart';
import 'package:mingly/src/screens/protected/profile/view/profile_screen.dart';
import 'package:mingly/src/screens/protected/profile/view_profile/view/view_profile_screen.dart';
import 'package:mingly/src/screens/protected/profile/voucher_list.dart';
import 'package:mingly/src/screens/protected/select_country_screen/select_country_screen.dart';
import 'package:mingly/src/screens/protected/select_payment_screen/select_payment_screen.dart';
import 'package:mingly/src/screens/protected/table_booking_screen/view/table_booking_screen.dart';
import 'package:mingly/src/screens/protected/ticket_booking_screen/view/ticket_booking_screen.dart';
import 'package:mingly/src/screens/protected/venue_detail_screen/view/venue_detail_screen.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/view/venue_list_screen.dart';
import 'package:mingly/src/screens/protected/venue_menu/view/venue_menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/booking/booking_list.dart';
import 'application/booking/ticket_booking.dart';
import 'application/payment/model/payment_from.dart';
import 'application/venues/model/venues_model.dart';
import 'screens/protected/country_list/view/country_list_screen.dart';
import 'screens/protected/my_reservation/view/my_reservations_screen.dart';
import 'screens/protected/payment/view/payment_stripe_screen.dart';
import 'screens/protected/promo_code/view/promo_code_screen.dart';
import 'screens/protected/reserve_venue/view/venue_reserve_screen.dart';
import 'screens/protected/table_booking_detail/view/table_booking_detail_screen.dart';
import 'screens/protected/ticket_booking_detail/view/ticket_booking_detail_screen.dart';

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
          builder: (context, state) =>
              OTPVerificationScreen(email: state.extra as String),
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
          builder: (context, state) =>
              EventListScreen(venueId: state.extra as int?),
        ),
        GoRoute(
          path: '/venue-list',
          builder: (context, state) => const VenueListScreen(),
        ),
        GoRoute(
          path: '/ticket-booking',
          builder: (context, state) =>
              TicketBookingScreen(info: state.extra as TicketBookInfoArg),
        ),
        GoRoute(
          path: '/venue-detail',
          builder: (context, state) {
            final venue = state.extra as VenuesModel;
            return VenueDetailScreen(venue: venue);
          },
        ),
        GoRoute(
          path: '/venue-reserve',
          builder: (context, state) {
            final venue = state.extra as VenuesModel;
            return VenueReserveScreen(venue: venue);
          },
        ),
        GoRoute(
          path: '/table-booking',
          builder: (context, state) =>
              TableBookingScreen(event: state.extra as EventsModel),
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
          path: '/my-menu',
          builder: (context, state) => const MyMenuScreen(),
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
          path: '/venue-menu',
          builder: (context, state) =>
              VenueMenuScreen(venueId: state.extra as int),
        ),
        GoRoute(
          path: '/event-detail',
          builder: (context, state) {
            final event =
                state.extra as EventsModel; // 👈 cast to your event model type
            return EventDetailScreen(event: event);
          },
        ),

        GoRoute(
          path: '/event-detail-one',
          builder: (context, state) => const EventDetailsScreenOne(),
        ),
        GoRoute(
          path: '/beverages',
          builder: (context, state) =>
              BeveragesScreen(venueId: state.extra as int),
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) => PaymentMethodScreen(),
        ),
        GoRoute(
          path: '/booking-confirmation',
          builder: (context, state) =>
              BookingConfirmationScreen(info: state.extra as TicketBookInfoArg),
        ),
        GoRoute(
          path: '/table-booking-confirmation',
          builder: (context, state) => TableBookingConfirmationScreen(
            info: state.extra as TicketBookInfoArg,
          ),
        ),
        GoRoute(
          path: '/promo-code',
          builder: (context, state) => PromoCodeScreen(),
        ),
        GoRoute(
          path: '/payment-table',
          builder: (context, state) => PaymentTable(),
        ),
        GoRoute(
          path: '/payment-screen',
          builder: (context, state) =>
              StripePaymentWebView(arg: state.extra as PaymentFromArg),
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
          builder: (context, state) => LeaderBoardScreen(),
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
          path: '/order-history-details',
          builder: (context, state) => OrderDetailsPage(),
        ),

        GoRoute(
          path: '/country-list',
          builder: (context, state) => const CountryListScreen(),
        ),
        // Shell routing for protected pages
        ShellRoute(
          builder: (context, state, child) => LandingPage(child: child),
          routes: [
            GoRoute(
              path: "/home",
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      // Only new screen slides in from right
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: '/my-bookings',
              builder: (context, state) => const MyBookingsScreen(),
            ),

            GoRoute(
              path: '/ticket-booking-detail',
              builder: (context, state) =>
                  TicketBookingDetail(booking: state.extra as BookingOrder),
            ),
            GoRoute(
              path: '/table-booking-detail',
              builder: (context, state) =>
                  TableBookingDetail(booking: state.extra as BookingOrder),
            ),
            GoRoute(
              path: '/my-reservation',

              builder: (context, state) => MyReservationsScreen(),
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
