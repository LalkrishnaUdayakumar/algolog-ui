import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/leave_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/leave_provider.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LeaveFilterType _selectedFilter = LeaveFilterType.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedFilter = LeaveFilterType.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser!.id;

    List<LeaveRequestModel> filteredLeaves;
    switch (_selectedFilter) {
      case LeaveFilterType.pending:
        filteredLeaves = leaveProvider.leaves
            .where((l) => l.status == LeaveStatus.pending)
            .toList();
        break;
      case LeaveFilterType.upcoming:
        // Upcoming could be approved leaves starting from tomorrow
        filteredLeaves = leaveProvider.leaves
            .where((l) =>
                l.status == LeaveStatus.approved &&
                l.startDate.isAfter(DateTime.now()))
            .toList();
        break;
      case LeaveFilterType.history:
        // History could be all past leaves (approved, rejected, or completed)
        filteredLeaves = leaveProvider.leaves
            .where((l) =>
                l.endDate.isBefore(
                    DateTime.now().subtract(const Duration(days: 1))) ||
                l.status == LeaveStatus.rejected)
            .toList();
        break;
      case LeaveFilterType.all:
      default:
        filteredLeaves = leaveProvider.leaves;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildLeaveStats(leaveProvider, userId),
          _buildTabBar(),
          Expanded(
            child: leaveProvider.isLoading && filteredLeaves.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredLeaves.isEmpty
                    ? Center(
                        child: Text("No leaves to display for this category.",
                            style: AppTextStyles.bodyTextMedium))
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        itemCount: filteredLeaves.length,
                        itemBuilder: (context, index) {
                          return _buildLeaveItem(
                              context, filteredLeaves[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveStats(LeaveProvider provider, String userId) {
    // TODO: API Call for Leave Stats if not already loaded or specifically needed here
    // provider.fetchLeaveStats(userId); // Assuming stats are part of fetchLeaves
    return Card(
      margin: const EdgeInsets.all(AppDimens.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leave Stats", style: AppTextStyles.heading3),
            const SizedBox(height: AppDimens.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Available", provider.availableLeaves.toString(),
                    AppColors.primary),
                _buildStatItem("Approved",
                    provider.approvedLeavesCount.toString(), AppColors.green),
                _buildStatItem("Pending",
                    provider.pendingLeavesCount.toString(), AppColors.orange),
              ],
            ),
            const SizedBox(
                height: AppDimens.paddingSmall), // Reduced from medium
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Ensure they are spaced
              children: [
                _buildStatItem(
                    "Applied",
                    provider.appliedLeavesCount.toString(),
                    AppColors.accent), // Total applied ever or this year
                _buildStatItem("Rejected",
                    provider.rejectedLeavesCount.toString(), AppColors.red),
                _buildStatItem(
                    "Total Leave",
                    provider.totalLeaveDaysTaken.toString(),
                    AppColors.darkGreyText), // total days taken this year
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.heading2
              .copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(label,
            style: AppTextStyles.bodyTextSmall
                .copyWith(color: AppColors.greyText)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMedium,
          vertical: AppDimens.paddingSmall),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ]),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.greyText,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          color: AppColors.primary.withOpacity(0.1),
        ),
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Pending"),
          Tab(text: "Upcoming"),
          Tab(text: "History"),
        ],
      ),
    );
  }

  Widget _buildLeaveItem(BuildContext context, LeaveRequestModel leave) {
    Color statusColor;
    String statusText;

    switch (leave.status) {
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
      default: // Includes upcoming if filtered by status
        statusColor = AppColors.greyText;
        statusText = "Unknown";
    }
    if (leave.status == LeaveStatus.approved &&
        leave.startDate.isAfter(DateTime.now())) {
      statusText = "Upcoming"; // Override for visual clarity in "All" tab
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRouter.leaveDetailRoute, arguments: leave.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(leave.leaveType,
                      style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingSmall, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimens.borderRadiusSmall),
                    ),
                    child: Text(
                      statusText,
                      style: AppTextStyles.bodyTextSmall.copyWith(
                          color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingSmall),
              Text(
                "${DateFormatter.formatToyMd(leave.startDate)} - ${DateFormatter.formatToyMd(leave.endDate)}",
                style: AppTextStyles.bodyTextMedium,
              ),
              const SizedBox(height: AppDimens.paddingSmall / 2),
              Text(
                "${leave.durationInDays.toStringAsFixed(0)} Days",
                style: AppTextStyles.bodyTextSmall
                    .copyWith(color: AppColors.greyText),
              ),
              if (leave.approvedBy != null &&
                  leave.status == LeaveStatus.approved) ...[
                const Divider(height: AppDimens.paddingMedium),
                Text(
                  "Approved By: ${leave.approvedBy}",
                  style: AppTextStyles.bodyTextSmall
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
