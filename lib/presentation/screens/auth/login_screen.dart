import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_assets.dart'; // For logo
import '../../providers/auth_provider.dart';
// import '../../../core/widgets/custom_button.dart'; // If you create one
// import '../../../core/widgets/custom_text_field.dart'; // If you create one

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: "test@example.com"); // Demo
  final _passwordController = TextEditingController(text: "password"); // Demo

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.mainWrapperRoute);
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Replace with your logo, e.g., Image.asset or SvgPicture.asset
                  // Image.asset(AppAssets.logoPlaceholder, height: 60),
                  const Icon(Icons.lock_outline,
                      size: 60, color: AppColors.primary), // Placeholder
                  const SizedBox(height: AppDimens.paddingSmall),
                  const Text("Prologic Solutions",
                      style:
                          AppTextStyles.heading3), // Placeholder for logo text
                  const SizedBox(height: AppDimens.paddingLarge * 2),
                  const Text('Welcome back', style: AppTextStyles.heading1),
                  const SizedBox(height: AppDimens.paddingSmall),
                  Text(
                    'Enter your email and password to login.',
                    style: AppTextStyles.bodyTextMedium
                        .copyWith(color: AppColors.greyText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.paddingLarge),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Your email/username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        // Basic check
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.paddingMedium),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Your password',
                      prefixIcon: Icon(Icons.lock_outline),
                      // TODO: Add suffix icon for password visibility toggle
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.paddingSmall),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRouter.forgotPasswordRoute);
                      },
                      child: const Text('Forgot password?',
                          style: AppTextStyles.linkText),
                    ),
                  ),
                  const SizedBox(height: AppDimens.paddingMedium),
                  authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                  const SizedBox(height: AppDimens.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: AppTextStyles.bodyTextMedium),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRouter.signupRoute);
                        },
                        child: const Text('Signup Now',
                            style: AppTextStyles.linkText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
