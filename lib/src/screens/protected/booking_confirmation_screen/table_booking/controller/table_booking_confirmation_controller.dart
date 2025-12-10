import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/payment/model/payment_from.dart';
import 'package:mingly/src/components/custom_snackbar.dart';

import '../../../../../application/booking/ticket_booking.dart';
import '../../../../../application/booking/ticket_success.dart';
import '../../../../../application/events/repo/events_repo.dart';
import '../../../../../application/promo_code/model/promo_code_model.dart';
import '../../../../../components/custom_loading_dialog.dart';

class TableBookingConfirmationController extends GetxController {
  final promoCodeApplied = false.obs;

  final eventRepo = EventsRepo();

  final promo = PromoCodeModel().obs;

  final List<TicketBuyingInfo> tickets;
  TableBookingConfirmationController({required this.tickets});

  Future<void> buyTicketEvent(
    BuildContext context, {
    required List<TicketBuyingInfo> items,
    required String bookingDate,
    required String promoCode,
    required EventsModel event,
    required int sessionId,
  }) async {
    try {
      int eventId = event.id!;
      int venueId = event.venue!.id!;

      LoadingDialog.show(context);

      final response = await eventRepo.buyEventTicket(
        TicketBooking(
          items: items,
          promoCode: promoCode,
          bookingDate: bookingDate,
          sessionId: sessionId,
        ).toJson(),
        eventId,
      );
      TicketBookingSuccess ticketBookingSuccess = TicketBookingSuccess.fromJson(
        response,
      );
      if (context.mounted) {
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: ticketBookingSuccess.checkoutUrl,
            venueId: venueId,
            fromScreen: FromScreen.tableBooking,
          ),
        );
      }
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    } catch (e, stack) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      debugPrint("Error buying tickets: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  // subtotal price
  RxDouble get getTicketPriceInTotal {
    return double.parse(
      tickets
          .fold<double>(0.0, (prev, t) => prev + (t.unitPrice * t.quantity))
          .toStringAsFixed(2),
    ).obs;
  }

  RxDouble get getServiceFee {
    return double.parse(
      (getTicketPriceInTotal.value * 0.1).toStringAsFixed(2),
    ).obs;
  }

  RxDouble promoValue = 0.0.obs;

  TextEditingController promoCodeController = TextEditingController();
  FocusNode promoFocusNode = FocusNode();

  RxString get getTotalPrice {
    return (getTicketPriceInTotal.value +
            getServiceFee.value -
            promoValue.value)
        .toStringAsFixed(2)
        .obs;
  }

  void storePromoCode(PromoCodeModel code) {
    promo.value = code;
  }

  /// Calculate discount based on discount type
  double _calculateDiscount(PromoCodeModel promo) {
    final discountValue = double.tryParse(promo.discountValue ?? "0") ?? 0.0;
    final discountType = (promo.discountType ?? "").toLowerCase();

    if (discountType == "percent") {
      // Calculate percentage discount
      return (getTicketPriceInTotal.value * discountValue) / 100;
    } else if (discountType == "fixed") {
      // Direct fixed amount discount
      return discountValue;
    }
    return 0.0;
  }

  void applyPromoCode(BuildContext context) async {
    LoadingDialog.show(context);
    try {
      final response = await eventRepo.verifyPromoCode({
        'promo_code': promoCodeController.text,
      });
      promoCodeApplied.value = true;
      promo.value = response;

      // Calculate discount based on type
      promoValue.value = _calculateDiscount(response);

      if (context.mounted) {
        LoadingDialog.hide(context);
        CustomSnackbar.show(
          context,
          message: "Promocode applied successfully",
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);

        String errorMessage = "Promocode not found";

        // Try to extract a useful message from different error shapes
        if (e is Map && e['error'] != null) {
          errorMessage = e['error'].toString();
        } else {
          final errStr = e.toString();
          if (errStr.contains("already used")) {
            errorMessage = "You have already used this promo code.";
          } else if (errStr.contains("invalid") || errStr.contains("expired")) {
            errorMessage = "Promo code is invalid or expired.";
          } else if (errStr.isNotEmpty) {
            errorMessage = errStr;
          }
        }

        CustomSnackbar.show(
          context,
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
