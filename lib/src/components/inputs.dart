import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomInputField extends StatefulWidget {
  final String? hintText;
  final SvgPicture? prefixSvg;
  final SvgPicture? suffixSvg;
  final bool isPassword;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final bool isMultiline;
  final int? maxLines;
  final int? minLines;

  const CustomInputField({
    super.key,
    this.hintText,
    this.prefixSvg,
    this.suffixSvg,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.isMultiline = false,
    this.maxLines,
    this.minLines,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      keyboardType: widget.isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: widget.isMultiline
          ? (widget.maxLines)
          : 1,
      minLines: widget.isMultiline
          ? (widget.minLines ?? 1)
          : 1,
      style: TextStyle(color: onSurface),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: onSurface.withAlpha(97)),
        prefixIcon: widget.prefixSvg != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: widget.prefixSvg,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixSvg != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.suffixSvg,
                  )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
            color: onSurface.withAlpha(178),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: onSurface.withAlpha(178),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}