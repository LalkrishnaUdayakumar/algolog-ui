import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_assets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/leave_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(
        context); // For user details if separate from auth
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final leaveProvider = Provider.of<LeaveProvider>(context);

    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("User not found.")));
    }
    // Ensure user details are fetched if UserProvider holds more info
    // This is usually done in MainWrapper or when ProfileScreen is first loaded.
    // Provider.of<UserProvider>(context, listen: false).fetchUserDetails(currentUser.id);
    // final userDetails = userProvider.userDetails ?? currentUser; // Fallback to auth user

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: AppColors.white),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(
                context, currentUser, attendanceProvider, leaveProvider),
            const SizedBox(
                height:
                    AppDimens.paddingSmall), // Space between header and list
            _buildProfileMenuList(context, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context,
      dynamic user, // Can be UserModel from AuthProvider or UserProvider
      AttendanceProvider attendanceProvider,
      LeaveProvider leaveProvider) {
    // TODO: API Calls for these stats if they need to be more specific or fetched on demand
    // For now, using mock/provider data
    final monthlyAttendance = attendanceProvider.monthlyAttendanceDays;
    final monthlyHours = attendanceProvider.monthlyHoursWorked;
    final monthlyLate = attendanceProvider.monthlyLateCount;
    final remainingLeaves =
        leaveProvider.availableLeaves; // 'Available' from leave stats

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl.isNotEmpty
                    ? NetworkImage(
                        user.profileImageUrl!) // TODO: Handle API for image
                    : AssetImage(AppAssets.profilePlaceholder)
                        as ImageProvider, // Placeholder
            backgroundColor: AppColors.lightGrey,
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          Text(
            user.name,
            style: AppTextStyles.heading2.copyWith(color: AppColors.white),
          ),
          Text(
            user.role ?? "Employee",
            style: AppTextStyles.bodyTextMedium
                .copyWith(color: AppColors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          IntrinsicHeight(
            // To make the dividers stretch
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(monthlyAttendance.toString(),
                    "Monthly\nAttendance", AppColors.white),
                const VerticalDivider(
                    color: AppColors.white,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5),
                _buildStatItem(
                    monthlyHours.toString(), "Monthly\nHours", AppColors.white),
                const VerticalDivider(
                    color: AppColors.white,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5),
                _buildStatItem(
                    monthlyLate.toString(), "Monthly\nLate", AppColors.white),
                const VerticalDivider(
                    color: AppColors.white,
                    thickness: 0.5,
                    indent: 5,
                    endIndent: 5),
                _buildStatItem(remainingLeaves.toString(), "Remaining\nLeaves",
                    AppColors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.heading3
              .copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimens.paddingSmall / 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyTextSmall
              .copyWith(color: textColor.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildProfileMenuList(
      BuildContext context, AuthProvider authProvider) {
    return Container(
      color: AppColors
          .background, // Ensures list items are on the general background
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: Column(
        children: [
          _buildMenuListItem(
            context,
            icon: Icons.person_outline,
            title: "Personal Information",
            onTap: () =>
                Navigator.of(context).pushNamed(AppRouter.personalInfoRoute),
          ),
          _buildMenuListItem(
            context,
            icon: Icons.work_outline,
            title: "Work Information",
            onTap: () =>
                Navigator.of(context).pushNamed(AppRouter.workInfoRoute),
          ),
          _buildMenuListItem(
            context,
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () =>
                Navigator.of(context).pushNamed(AppRouter.changePasswordRoute),
          ),
          _buildMenuListItem(
            context,
            icon: Icons.settings_outlined,
            title: "Settings",
            onTap: () {
              // TODO: Navigate to Settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Settings screen not implemented.")),
              );
            },
          ),
          const SizedBox(height: AppDimens.paddingSmall), // Space before logout
          _buildMenuListItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            iconColor: AppColors.red,
            textColor: AppColors.red,
            showTrailingIcon: false,
            onTap: () async {
              // TODO: Show confirmation dialog before logout
              await authProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.loginRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool showTrailingIcon = true,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMedium,
          vertical: AppDimens.paddingSmall / 2),
      elevation: 1, // Subtle elevation
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall)),
      child: ListTile(
        leading: Icon(icon,
            color: iconColor ?? AppColors.primary,
            size: AppDimens.iconSizeMedium),
        title: Text(title,
            style: AppTextStyles.bodyTextLarge.copyWith(
                color: textColor ?? AppColors.darkGreyText,
                fontWeight: FontWeight.w500)),
        trailing: showTrailingIcon
            ? const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.greyText)
            : null,
        onTap: onTap,
      ),
    );
  }
}
