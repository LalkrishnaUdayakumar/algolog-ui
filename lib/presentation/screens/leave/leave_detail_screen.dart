import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/leave_model.dart';
import '../../providers/leave_provider.dart';

class LeaveDetailScreen extends StatelessWidget {
  final String leaveId;

  const LeaveDetailScreen({super.key, required this.leaveId});

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    // TODO: API Call: Fetch specific leave detail if not already in the list or needs refresh
    // For now, find from the existing list
    final LeaveRequestModel? leaveDetail = leaveProvider.leaves.firstWhere(
      (leave) => leave.id == leaveId,
      orElse: () => LeaveRequestModel(
          // Fallback if not found (should not happen in ideal scenario)
          id: 'not_found',
          userId: '',
          leaveType: 'Unknown',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          appliedDate: DateTime.now(),
          status: LeaveStatus.pending,
          description: 'Leave details not found.'),
    );

    if (leaveDetail == null || leaveDetail.id == 'not_found') {
      return Scaffold(
          appBar: AppBar(title: const Text("Leave Details")),
          body: const Center(
              child: Text("Leave not found or error loading details.")));
    }

    Color statusColor;
    String statusText;
    switch (leaveDetail.status) {
      case LeaveStatus.approved:
        statusColor = AppColors.green;
        statusText = "Approved";
        break;
      case LeaveStatus.pending:
        statusColor = AppColors.orange;
        statusText = "Pending";
        break;
      case LeaveStatus.rejected:
        statusColor = AppColors.red;
        statusText = "Rejected";
        break;
      default:
        statusColor = AppColors.greyText;
        statusText = "Unknown";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${leaveDetail.leaveType} Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Card(
          elevation: 0, // Design shows it flush
          color:
              AppColors.white, // Explicitly set as the background is light grey
          shape: RoundedRectangleBorder(
            // Ensure consistent card styling
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  // As per design: "Alish KC on Unpaid Leave: 1 days"
                  // Assuming the user's name should be here, but we don't have it directly in LeaveRequestModel
                  // We can fetch it via AuthProvider or UserProvider if needed. For now, generic.
                  "Leave: ${leaveDetail.durationInDays.toStringAsFixed(0)} days",
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: AppDimens.paddingMedium),
                _buildDetailRow("Leave Type:", leaveDetail.leaveType),
                _buildDetailRow("From:",
                    DateFormatter.formatToddMMyyyy(leaveDetail.startDate)),
                _buildDetailRow(
                    "To:", DateFormatter.formatToddMMyyyy(leaveDetail.endDate)),
                _buildDetailRow("Duration:",
                    "${leaveDetail.durationInDays.toStringAsFixed(0)} Days"),
                _buildDetailRow("Applied on:",
                    DateFormatter.formatToddMMyyyy(leaveDetail.appliedDate)),
                if (leaveDetail.appliedTo != null)
                  _buildDetailRow("Applied To:", leaveDetail.appliedTo!),
                _buildDetailRow(
                  "Status:",
                  statusText,
                  valueStyle: AppTextStyles.bodyTextLarge.copyWith(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
                if (leaveDetail.approvedBy != null &&
                    leaveDetail.status == LeaveStatus.approved)
                  _buildDetailRow("Approved By:", leaveDetail.approvedBy!),
                if (leaveDetail.description != null &&
                    leaveDetail.description!.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.paddingSmall),
                  const Text("Description:",
                      style: AppTextStyles.bodyTextLarge),
                  const SizedBox(height: AppDimens.paddingSmall / 2),
                  Text(
                    leaveDetail.description!,
                    style: AppTextStyles.bodyTextMedium
                        .copyWith(color: AppColors.darkGreyText),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall / 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label,
              style: AppTextStyles.bodyTextLarge
                  .copyWith(color: AppColors.greyText)),
          Text(value,
              style: valueStyle ??
                  AppTextStyles.bodyTextLarge
                      .copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
