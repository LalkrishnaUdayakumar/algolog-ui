import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_assets.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success =
        await authProvider.forgotPassword(_emailController.text.trim());

    if (success && mounted) {
      // Show "Check your mail" screen/dialog
      _showCheckMailDialog();
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(authProvider.errorMessage ?? "Failed to send reset link."),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  void _showCheckMailDialog() {
    // In a real app, this might navigate to a new screen as per design
    // For simplicity, using a dialog here
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              contentPadding: const EdgeInsets.all(AppDimens.paddingLarge),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimens.borderRadiusMedium)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.mailIcon,
                      height: 80, width: 80), // Make sure you have this asset
                  const SizedBox(height: AppDimens.paddingMedium),
                  const Text("Check your mail", style: AppTextStyles.heading2),
                  const SizedBox(height: AppDimens.paddingSmall),
                  Text(
                    "Please check your email and click on the link to reset your new password.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextMedium
                        .copyWith(color: AppColors.greyText),
                  ),
                  const SizedBox(height: AppDimens.paddingLarge),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      // Optionally navigate to login or a screen to enter OTP/new password
                      // For now, just pop. The design implies next screen is "Password Changed"
                      // which would happen AFTER user clicks link and resets.
                      // Let's assume the user clicks the link and then would eventually
                      // be redirected to a page to set a new password.
                      // We can simulate going to login.
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.loginRoute, (route) => false);
                    },
                    child: const Text("OK"),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Placeholder for the large mail icon shown in "Check your mail" but used here for context
              // Image.asset(AppAssets.mailIcon, height: 100, color: AppColors.primary.withOpacity(0.2)),
              Icon(Icons.email_outlined,
                  size: 80, color: AppColors.primary.withOpacity(0.7)),
              const SizedBox(height: AppDimens.paddingLarge),
              const Text('Forgot Your Password?',
                  style: AppTextStyles.heading1),
              const SizedBox(height: AppDimens.paddingSmall),
              Text(
                'Enter your email address below and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextMedium
                    .copyWith(color: AppColors.greyText),
              ),
              const SizedBox(height: AppDimens.paddingLarge),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimens.paddingLarge),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendResetLink,
                        child: const Text('Send Reset Link'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
