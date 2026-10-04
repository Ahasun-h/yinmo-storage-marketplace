// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/colors.gen.dart';

class CommonTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPrefixIcon;
  final double borderRadius;
  final VoidCallback? onSuffixIconTap;
  final String? iconpath;
  final int maxline;
  final int? minLines;
  final bool readOnly;
  final bool isBorder;
  final Color fillColor;
  final Color? borderColor;
  // final Color? textInputColor;
  final Color? focusBorderColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final TextStyle? labelStyle;
  final void Function()? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  const CommonTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.borderRadius = 12,
    required this.isPrefixIcon,
    this.iconpath,
    this.onSuffixIconTap,
    this.readOnly = false,
    this.maxline = 1,
    this.isBorder = true,
    this.fillColor = AppColors.cFFFFFF,
    this.hintStyle,
    this.height,
    this.minLines,
    // this.textInputColor,
    this.textAlign,
    this.textInputStyle,
    this.focusBorderColor,
    this.cursorColor,
    this.textInputAction,
    this.borderColor,
    this.maxLength,
    this.labelStyle,
    this.onTap,
    this.contentPadding,
    this.onFieldSubmitted,
    this.focusNode,
    this.autovalidateMode,
    this.inputFormatters,
  });

  @override
  _CommonTextFormFieldState createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        //  isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      autovalidateMode: widget.autovalidateMode,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      textAlign: widget.textAlign ?? TextAlign.start,
      readOnly: widget.readOnly,
      maxLines: widget.maxline,
      minLines: widget.minLines,
      focusNode: widget.focusNode ?? _focusNode,
      cursorColor: widget.cursorColor ?? AppColors.c000000,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
        // floatingLabelAlignment: FloatingLabelAlignment.center,
        filled: true,
        fillColor: widget.fillColor,
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: widget.labelStyle,

        hintStyle: widget.hintStyle ??
            TextStyle(
              color: const Color(0x7F101010),
              fontSize: 12.sp,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
        prefixIcon: widget.isPrefixIcon ? widget.prefixIcon : null,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: widget.isBorder == true
              ? BorderSide(
                  color: widget.borderColor ?? const Color(0x51919EAB),
                  width: 1.w,
                )
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.focusBorderColor ?? AppColors.primaryColor,
            width: 1.w, // Adjust the border width if needed
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        disabledBorder: InputBorder.none,
      ),
      style: widget.textInputStyle ??
          TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
      onTap: widget.onTap,
    );
  }
}
