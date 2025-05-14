import 'package:algolog/presentation/screens/profile/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/auth/password_changed_screen.dart';
import 'presentation/screens/leave/leave_request_screen.dart';
import 'presentation/screens/leave/leave_detail_screen.dart';
import 'presentation/screens/profile/work_info_screen.dart';
import 'presentation/screens/profile/change_password_screen.dart';
import 'presentation/screens/main_wrapper_screen.dart'; // Will create this

class AppRouter {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String passwordChangedRoute = '/password-changed';
  static const String mainWrapperRoute =
      '/main-wrapper'; // Home, Leave, Profile container
  static const String homeRoute = '/home'; // Technically part of mainWrapper
  static const String leaveListRoute =
      '/leave-list'; // Technically part of mainWrapper
  static const String leaveRequestRoute = '/leave-request';
  static const String leaveDetailRoute = '/leave-detail';
  static const String profileRoute =
      '/profile'; // Technically part of mainWrapper
  static const String personalInfoRoute = '/personal-info';
  static const String workInfoRoute = '/work-info';
  static const String changePasswordRoute = '/change-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case passwordChangedRoute:
        return MaterialPageRoute(builder: (_) => PasswordChangedScreen());
      case mainWrapperRoute:
        return MaterialPageRoute(builder: (_) => MainWrapperScreen());
      // Details screens that push on top
      case leaveRequestRoute:
        return MaterialPageRoute(builder: (_) => LeaveRequestScreen());
      case leaveDetailRoute:
        final args = settings.arguments as String; // leaveId
        return MaterialPageRoute(
            builder: (_) => LeaveDetailScreen(leaveId: args));
      case personalInfoRoute:
        return MaterialPageRoute(builder: (_) => PersonalInfoScreen());
      case workInfoRoute:
        return MaterialPageRoute(builder: (_) => WorkInfoScreen());
      case changePasswordRoute:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      // These are handled by MainWrapperScreen's BottomNavigationBar, but good to have defined
      // case homeRoute:
      //   return MaterialPageRoute(builder: (_) => HomeScreen());
      // case leaveListRoute:
      //   return MaterialPageRoute(builder: (_) => LeaveListScreen());
      // case profileRoute:
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
