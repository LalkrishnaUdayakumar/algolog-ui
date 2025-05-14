import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../../data/models/attendance_model.dart'; // For AttendanceType and AttendanceRecordModel

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds HRS";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("User not logged in.")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentUser.name,
                style: AppTextStyles.heading3.copyWith(color: AppColors.white)),
            Text(currentUser.role,
                style: AppTextStyles.bodyTextSmall
                    .copyWith(color: AppColors.white.withOpacity(0.8))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                color: AppColors.white),
            onPressed: () {
              // TODO: Implement notification screen or action
            },
          ),
        ],
        automaticallyImplyLeading: false, // No back button on home
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateAndTimerSection(context, attendanceProvider),
            const SizedBox(height: AppDimens.paddingMedium),
            _buildPunchActions(context, attendanceProvider, currentUser.id),
            const SizedBox(height: AppDimens.paddingLarge),
            _buildWorkingHoursSummary(attendanceProvider),
            const SizedBox(height: AppDimens.paddingLarge),
            _buildActivitySection(attendanceProvider),
            // The "Leave Request" and "Application Pending" sections are not part of the Home Screen in the design.
            // They are shown on the Leave page or as specific project details.
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndTimerSection(
      BuildContext context, AttendanceProvider attendanceProvider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(DateTime.now()),
                  style: AppTextStyles.bodyTextLarge
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('EEEE').format(DateTime.now()),
                  style: AppTextStyles.bodyTextMedium
                      .copyWith(color: AppColors.greyText),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            Text(
              _formatDuration(attendanceProvider.currentWorkDuration),
              style: AppTextStyles.heading1
                  .copyWith(fontSize: 36, color: AppColors.primary),
            ),
            const SizedBox(height: AppDimens.paddingSmall),
            Text(
              "General 10:00 AM to 06:00 PM", // TODO: Make this dynamic from user settings/company policy
              style: AppTextStyles.bodyTextSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPunchActions(BuildContext context,
      AttendanceProvider attendanceProvider, String userId) {
    bool isPunchedIn = attendanceProvider.isPunchedIn;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.login, size: AppDimens.iconSizeMedium),
            label: const Text(
                "Work time"), // Design says "Work time", implies punch in
            onPressed: isPunchedIn
                ? null
                : () async {
                    // TODO: API call for Punch In
                    await attendanceProvider.punchIn(userId);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isPunchedIn
                  ? AppColors.greyText.withOpacity(0.5)
                  : AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(vertical: AppDimens.paddingMedium),
            ),
          ),
        ),
        const SizedBox(width: AppDimens.paddingMedium),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout, size: AppDimens.iconSizeMedium),
            label: const Text("Check out"),
            onPressed: !isPunchedIn
                ? null
                : () async {
                    // TODO: API call for Punch Out
                    await attendanceProvider.punchOut(userId);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: !isPunchedIn
                  ? AppColors.greyText.withOpacity(0.5)
                  : AppColors.red,
              padding:
                  const EdgeInsets.symmetric(vertical: AppDimens.paddingMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingHoursSummary(AttendanceProvider attendanceProvider) {
    // This section shows specific punch in/out times for the day.
    // We need to extract these from attendanceProvider.todayAttendance
    // Simplified for now.

    DateTime? checkInTime;
    DateTime? breakInTime;
    DateTime? breakOutTime;
    DateTime? checkOutTime;

    for (var record in attendanceProvider.todayAttendance) {
      if (record.type == AttendanceType.checkIn && checkInTime == null)
        checkInTime = record.timestamp; // First check-in
      if (record.type == AttendanceType.breakIn && breakInTime == null)
        breakInTime = record.timestamp;
      if (record.type == AttendanceType.breakOut && breakOutTime == null)
        breakOutTime = record.timestamp;
      if (record.type == AttendanceType.checkOut)
        checkOutTime = record.timestamp; // Last check-out
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today working hour", style: AppTextStyles.heading3),
        const SizedBox(height: AppDimens.paddingSmall),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn(
                    "Check In", checkInTime, Icons.input, AppColors.green),
                _buildTimeColumn("Break In", breakInTime,
                    Icons.free_breakfast_outlined, AppColors.orange),
                // Break Out is not in the design, but Break In is. Assuming it means total break duration or last break.
                // _buildTimeColumn("Break Out", breakOutTime, Icons.directions_run, AppColors.orange),
                _buildTimeColumn(
                    "Check Out", checkOutTime, Icons.output, AppColors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColumn(
      String label, DateTime? time, IconData icon, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: AppDimens.iconSizeLarge),
        const SizedBox(height: AppDimens.paddingSmall / 2),
        Text(label, style: AppTextStyles.bodyTextSmall),
        const SizedBox(height: AppDimens.paddingSmall / 2),
        Text(
          time != null ? DateFormatter.formatToTime(time) : "--:--",
          style:
              AppTextStyles.bodyTextLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActivitySection(AttendanceProvider attendanceProvider) {
    final activities = attendanceProvider
        .todayAttendance; // Already sorted descending by provider

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Your Activity", style: AppTextStyles.heading3),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full activity log screen
              },
              child: const Text("View All", style: AppTextStyles.linkText),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.paddingSmall),
        if (attendanceProvider.isLoading && activities.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (activities.isEmpty)
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: Text(
                "No activity recorded for today.",
                style: AppTextStyles.bodyTextMedium,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 3
                ? 3
                : activities.length, // Show limited items
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          ),
      ],
    );
  }

  Widget _buildActivityItem(AttendanceRecordModel activity) {
    String title;
    IconData icon;
    Color iconColor;
    String statusText = "";

    switch (activity.type) {
      case AttendanceType.checkIn:
        title = "Check In";
        icon = Icons.login;
        iconColor = AppColors.green;
        if (activity.status == AttendanceStatus.onTime) statusText = "On Time";
        if (activity.status == AttendanceStatus.late) statusText = "Late";
        break;
      case AttendanceType.checkOut:
        title = "Check Out";
        icon = Icons.logout;
        iconColor = AppColors.red;
        if (activity.status == AttendanceStatus.earlyOut)
          statusText = "Early Out";
        break;
      case AttendanceType.breakIn:
        title = "Break In";
        icon = Icons.free_breakfast_outlined;
        iconColor = AppColors.orange;
        break;
      case AttendanceType.breakOut:
        title = "Break Out";
        icon = Icons.directions_run_outlined;
        iconColor = AppColors.orange;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: AppDimens.iconSizeMedium),
        ),
        title: Text(title,
            style: AppTextStyles.bodyTextLarge
                .copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          "${DateFormatter.formatToyMd(activity.timestamp)} ${statusText.isNotEmpty ? ' - $statusText' : ''}",
          style: AppTextStyles.bodyTextSmall,
        ),
        trailing: Text(
          DateFormatter.formatToTime(activity.timestamp),
          style: AppTextStyles.bodyTextMedium
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
