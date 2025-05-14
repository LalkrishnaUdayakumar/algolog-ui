import 'package:flutter/material.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_assets.dart'; // For checkmark icon

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // You'll need a checkmark image asset
            Image.asset(AppAssets.checkmarkIcon,
                height: 100, width: 100), // Ensure you have this asset
            const SizedBox(height: AppDimens.paddingLarge),
            const Text(
              'Password Changed!',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: AppDimens.paddingSmall),
            Text(
              'Your new password has been set successfully. You can now log in to your account.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextMedium
                  .copyWith(color: AppColors.greyText),
            ),
            const SizedBox(height: AppDimens.paddingLarge * 2),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.loginRoute, (route) => false);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
