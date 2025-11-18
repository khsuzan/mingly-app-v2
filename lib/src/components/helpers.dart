import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/buttons.dart';
import 'package:intl/intl.dart';
import 'inputs.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geolocator/geolocator.dart';

/// A customizable primary button widget that displays a gradient background.
///
/// This widget wraps a [GradientButton] and provides a consistent style for primary actions.
///
/// - [text]: The label displayed on the button.
/// - [onPressed]: The callback triggered when the button is pressed.
///
/// The button uses a fixed gradient color scheme and does not expand to full width.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return GradientButton(
      text: text,
      onPressed: onPressed,
      gradientColors: const [Color(0xFFF7D99A), Color(0xFFC3A266)],
      fullWidth: false,
      textStyle: TextStyle(
        color: onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    );
  }
}
class PrimaryButtonSmall extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButtonSmall({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return GradientButton(
      text: text,
      onPressed: onPressed,
      height: 28,
      gradientColors: const [Color(0xFFF7D99A), Color(0xFFC3A266)],
      fullWidth: false,
      textStyle: TextStyle(
        color: onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    );
  }
}

/// A single-line text field using [CustomInputField] from inputs.dart.
///
/// - [controller]: Controls the text being edited.
/// - [hintText]: Placeholder text shown when the field is empty.
/// - [onChanged]: Callback when the text changes.

class SingleLineTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Widget? prefixSvg;

  const SingleLineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.onChanged,
    this.prefixSvg,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      focusNode: focusNode,
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      maxLines: 1,
      minLines: 1,
      isMultiline: false,
      isPassword: false,
      prefixSvg: prefixSvg as SvgPicture?,
    );
  }
}

/// A password input field using [CustomInputField] from inputs.dart.
///
/// This widget provides a secure text field for password entry, hiding the input by default.
///
/// - [controller]: Controls the text being edited.
/// - [hintText]: Placeholder text shown when the field is empty.
/// - [onChanged]: Callback when the text changes.
/// - [obscureText]: Whether to obscure the text (defaults to true).
///
/// The field uses a single line and disables suggestions and autocorrect for privacy.

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Widget? prefixSvg;

  const PasswordInputField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.onChanged,
    this.prefixSvg,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      hintText: widget.hintText,
      onChanged: widget.onChanged,
      maxLines: 1,
      minLines: 1,
      isMultiline: false,
      isPassword: true,
      prefixSvg: widget.prefixSvg as SvgPicture?,
    );
  }
}

String formatTimeToAmPm(String time24) {
  try {
    // Parse input time (24-hour format)
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);

    // Convert to 12-hour format with AM/PM
    return DateFormat("hh:mm a").format(dateTime);
  } catch (e) {
    // In case of invalid input, return original
    return time24;
  }
}

String formatDate(String isoString) {
  try {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat("dd MMM yyyy").format(dateTime);
  } catch (e) {
    return isoString; // fallback if invalid
  }
}

String formatDayAndDate(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    String day = DateFormat('EEE').format(dateTime); // Mon, Tue, etc.
    String date = DateFormat('dd MMM yyyy').format(dateTime); // 14 Nov 2025
    return "$day, $date";
  } catch (e) {
    return dateString;
  }
}

String formatDateTime(String utcString) {
  try {
    // Parse UTC string and convert to local time
    DateTime dateTime = DateTime.parse(utcString).toLocal();

    // Format date and time
    String datePart = DateFormat("dd").format(dateTime);
    String monthPart = DateFormat("MMM").format(dateTime).toUpperCase();
    String timePart = DateFormat("ha").format(dateTime).toUpperCase();

    return "$datePart $monthPart, $timePart";
  } catch (e) {
    // Return original string if parsing fails
    return utcString;
  }
}

Future<void> openMapToAddress(String destinationAddress) async {
  // Step 1: Get permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permission denied';
    }
  }

  // Step 2: Get current position
  Position position = await Geolocator.getCurrentPosition();

  // Step 3: Create the URL
  final Uri googleMapUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&origin=${position.latitude},${position.longitude}'
    '&destination=${Uri.encodeComponent(destinationAddress)}'
    '&travelmode=driving',
  );

  // Step 4: Try opening in external app first, fallback to browser
  try {
    final launched = await launchUrl(
      googleMapUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      // fallback to browser
      await launchUrl(googleMapUrl, mode: LaunchMode.inAppBrowserView);
    }
  } catch (e) {
    // ultimate fallback
    await launchUrl(googleMapUrl, mode: LaunchMode.platformDefault);
  }
}

class NoImage extends StatelessWidget {
  const NoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/noimage.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

abstract class GetxScreen<T extends GetxController> extends StatefulWidget {
  final T Function() controller;
  const GetxScreen({required this.controller, super.key});

  Widget build(BuildContext context, T controller);

  
}

class _GetxScreenState<T extends GetxController> extends State<GetxScreen<T>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(widget.controller(), permanent: false);
  }

  @override
  void dispose() {
    Get.delete<T>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, controller);
  }
}