import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../application/payment/model/payment_from.dart';

class StripePaymentWebView extends StatefulWidget {
  final PaymentFromArg arg;

  const StripePaymentWebView({super.key, required this.arg});

  @override
  State<StripePaymentWebView> createState() => _StripePaymentWebViewState();
}

class _StripePaymentWebViewState extends State<StripePaymentWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasShownError = false; // Prevent duplicate error messages

  // Use the actual URL from your backend/Stripe success redirect
  final String successUrlPattern = "success/";
  final String cancelUrlPattern = "cancel";
  // Professional SnackBar helper methods
  void _showSuccessSnackBar() {
    CustomSnackbar.show(
      context,
      message: "Payment Successful!\nYour ticket buy payment done",
    );
  }

  void _showCancelledSnackBar() {
    CustomSnackbar.show(
      message: 'Payment Cancelled\nYou can try again anytime',
      context,
    );
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.arg.url);
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                isLoading = true;
                hasShownError = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            if (kDebugMode) {
              print("WebView error: ${error.description}");
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (kDebugMode) {
              print("Navigation: ${request.url}");
            }

            // ✅ Detect PayFast success
            if (request.url.contains(successUrlPattern)) {
              _showSuccessSnackBar();
              if (mounted) {
                LoadingDialog.show(context);
              }
              Future.delayed(Duration(seconds: 5), () {
                if (mounted) {
                  LoadingDialog.hide(context);
                  if (widget.arg.fromScreen == FromScreen.ticketBooking ||
                      widget.arg.fromScreen == FromScreen.tableBooking) {
                    context.go('/home');
                    context.push('/venue-menu', extra: widget.arg.venueId);
                  } else if (widget.arg.fromScreen == FromScreen.menuBooking) {
                    context.go('/home');
                    context.push('/my-menu');
                  } else if (widget.arg.fromScreen ==
                      FromScreen.reservationPayment) {
                    context.go('/home');
                    context.push('/my-reservation');
                  } else if (widget.arg.fromScreen ==
                      FromScreen.membershipPayment) {
                    context.pop();
                    context.push('/membership');
                  }
                }
              });
              // All previous routes including /payment are removed from the stack
              return NavigationDecision.prevent;
            }
            // ✅ Detect PayFast cancel
            if (request.url.contains(cancelUrlPattern)) {
              _showCancelledSnackBar();
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.arg.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green),
            SizedBox(width: 12),
            Text(
              'Secure Payment',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black.withAlpha((255 * 0.1).toInt()),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            // Don't show cancellation message if user just closes without starting payment
            if (!isLoading) {
              _showCancelledSnackBar();
            }
            Navigator.of(context).pop(false);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black54),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha((255 * 0.1).toInt()),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Loading Payment Gateway...',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please wait while we connect securely',
                        style: TextStyle(color: Colors.black38, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
