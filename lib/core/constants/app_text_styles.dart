import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreyText,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGreyText,
  );

  static const TextStyle bodyTextLarge = TextStyle(
    fontSize: 16,
    color: AppColors.darkGreyText,
  );

  static const TextStyle bodyTextMedium = TextStyle(
    fontSize: 14,
    color: AppColors.darkGreyText,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontSize: 12,
    color: AppColors.greyText,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );
}
