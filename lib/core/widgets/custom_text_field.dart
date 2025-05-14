import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      style: AppTextStyles.bodyTextLarge,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle:
            AppTextStyles.bodyTextMedium.copyWith(color: AppColors.greyText),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon,
                color: AppColors.greyText, size: AppDimens.iconSizeMedium)
            : null,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon,
                    color: AppColors.greyText, size: AppDimens.iconSizeMedium),
                onPressed: widget.onSuffixIconTap,
              )
            : null,
        // Using theme's default for border, focusedBorder, etc.
        // Or you can customize them here:
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        //   borderSide: const BorderSide(color: AppColors.lightGrey),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        //   borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        //   borderSide: const BorderSide(color: AppColors.lightGrey),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        //   borderSide: const BorderSide(color: AppColors.red),
        // ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
        //   borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        // ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingMedium,
            vertical: AppDimens.paddingMedium),
      ),
    );
  }
}
