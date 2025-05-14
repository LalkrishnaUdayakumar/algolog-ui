import 'package:algolog/core/constants/app_dimens.dart';
import 'package:algolog/core/constants/app_text_styles.dart';
import 'package:algolog/core/widgets/splash_screen.dart';
import 'package:algolog/presentation/providers/attendance_provider.dart';
import 'package:algolog/presentation/providers/leave_provider.dart';
import 'package:algolog/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'core/constants/app_colors.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/attendance_repository.dart';
import 'data/repositories/leave_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/main_wrapper_screen.dart';

void main() {
  // Initialize Repositories (singletons or provided)
  final authRepository = AuthRepository();
  final userRepository =
      UserRepository(authRepository); // Pass authRepo if needed for mock
  final attendanceRepository = AttendanceRepository();
  final leaveRepository = LeaveRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
        ChangeNotifierProvider(
            create: (_) => AttendanceProvider(attendanceRepository)),
        ChangeNotifierProvider(create: (_) => LeaveProvider(leaveRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee HR App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins', // Add Poppins font or use system default
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
          titleTextStyle: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            ),
            textStyle: AppTextStyles.buttonText,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMedium,
              vertical: AppDimens.paddingMedium),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle:
              AppTextStyles.bodyTextMedium.copyWith(color: AppColors.greyText),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: EdgeInsets.zero, // Control margin where card is used
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          ),
          color: AppColors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.greyText,
          selectedLabelStyle: AppTextStyles.bodyTextSmall
              .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyles.bodyTextSmall,
          type: BottomNavigationBarType
              .fixed, // Ensures labels are always visible
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      // Initial route logic: Check if user is logged in
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading && auth.currentUser == null) {
            // Initial loading state
            return SplashScreen(); // Show splash while checking auth
          } else if (auth.currentUser != null) {
            // Fetch initial data for logged-in user
            // It's better to do this when the respective screens are loaded
            // Or use a dedicated method in AuthProvider after login success.
            return MainWrapperScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
