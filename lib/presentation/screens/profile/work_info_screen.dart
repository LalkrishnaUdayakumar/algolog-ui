import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart'; // Or UserProvider if it has work details

class WorkInfoScreen extends StatelessWidget {
  const WorkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming work details are part of the UserModel in AuthProvider
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (user == null) {
      return Scaffold(
          appBar: AppBar(title: const Text("Work Information")),
          body: const Center(child: Text("User not loaded.")));
    }

    // TODO: API Call to fetch detailed work info if not available in current user model
    // For now, using fields from UserModel

    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Information"),
        // No "Edit" button as per most designs for work info (often system-managed)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Work Details", style: AppTextStyles.heading3),
            const SizedBox(height: AppDimens.paddingSmall),
            _buildInfoRow("Username",
                user.name), // Username or Full Name depending on context
            _buildInfoRow("Employee ID", user.employeeId ?? "-"),
            _buildInfoRow(
                "Date of Joining",
                user.dateOfJoining != null
                    ? DateFormatter.formatToddMMyyyy(user.dateOfJoining!)
                    : "-"),
            _buildInfoRow("Department", user.department ?? "-"),
            _buildInfoRow("Designation",
                user.designation ?? user.role ?? "-"), // Fallback to role
            _buildInfoRow("Work Phone", user.workPhone ?? "-"),
            _buildInfoRow("Work Email", user.workEmail ?? "-"),
            _buildInfoRow("Work Location", user.workLocation ?? "-"),
            _buildInfoRow("Manager", user.managerName ?? "-"),
            _buildInfoRow("Employee Contract Type", user.contractType ?? "-"),
            const SizedBox(height: AppDimens.paddingLarge),
            const Text("Bank Details", style: AppTextStyles.heading3),
            const SizedBox(height: AppDimens.paddingSmall),
            _buildInfoRow("Bank Name", user.bankName ?? "-"),
            _buildInfoRow("Account Number", user.accountNumber ?? "-"),
            _buildInfoRow("Branch Address", user.branchAddress ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.bodyTextSmall
                  .copyWith(color: AppColors.greyText)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.bodyTextLarge
                  .copyWith(fontWeight: FontWeight.w500)),
          const Divider(height: AppDimens.paddingMedium, thickness: 0.5),
        ],
      ),
    );
  }
}
