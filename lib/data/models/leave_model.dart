enum LeaveStatus {
  pending,
  approved,
  rejected,
  upcoming,
  history
} // History is a filter, not a status

enum LeaveFilterType { all, pending, upcoming, history } // For UI tabs

class LeaveRequestModel {
  final String id;
  final String userId;
  String leaveType; // e.g., "Sick Leave", "Unpaid Leave"
  DateTime startDate;
  DateTime endDate;
  double get durationInDays {
    // Basic calculation, can be made more robust
    if (endDate.isBefore(startDate)) return 0;
    return endDate.difference(startDate).inDays + 1.0;
  }

  DateTime appliedDate;
  String? appliedTo; // Manager/Admin name
  LeaveStatus status;
  String? description;
  String? approvedBy;

  LeaveRequestModel({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.appliedDate,
    this.appliedTo,
    required this.status,
    this.description,
    this.approvedBy,
  });
  // TODO: Add fromJson and toJson methods for API integration
}
