import '../models/leave_model.dart';

class LeaveRepository {
  final List<LeaveRequestModel> _mockLeaves = [
    LeaveRequestModel(
        id: "leave1",
        userId: "user123",
        leaveType: "Sick Leave",
        startDate: DateTime(2023, 9, 12),
        endDate: DateTime(2023, 9, 13),
        appliedDate: DateTime(2023, 9, 10),
        status: LeaveStatus.approved,
        approvedBy: "Employee Name",
        description: "Need to go to the hospital for checkup."),
    LeaveRequestModel(
        id: "leave2",
        userId: "user123",
        leaveType: "Unpaid Leave",
        startDate: DateTime(2023, 9, 19),
        endDate: DateTime(2023, 9, 19),
        appliedDate: DateTime(2023, 9, 15),
        status: LeaveStatus.pending,
        appliedTo: "Manager Name",
        description: "Personal reasons."),
    LeaveRequestModel(
        id: "leave3",
        userId: "user123",
        leaveType: "Vacation",
        startDate: DateTime(2023, 8, 1),
        endDate: DateTime(2023, 8, 5),
        appliedDate: DateTime(2023, 7, 20),
        status: LeaveStatus.rejected, // To show a rejected example
        approvedBy: "HR Dept",
        description: "Annual vacation."),
  ];

  Future<List<LeaveRequestModel>> getLeaveHistory(String userId) async {
    // TODO: API call to get leave history
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLeaves.where((leave) => leave.userId == userId).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Future<LeaveRequestModel> applyForLeave(
      LeaveRequestModel leaveRequest) async {
    // TODO: API call to apply for leave
    await Future.delayed(const Duration(seconds: 1));
    final newLeave = LeaveRequestModel(
        id: "leaveNew${DateTime.now().millisecondsSinceEpoch}",
        userId: leaveRequest.userId,
        leaveType: leaveRequest.leaveType,
        startDate: leaveRequest.startDate,
        endDate: leaveRequest.endDate,
        appliedDate: DateTime.now(),
        status: LeaveStatus.pending,
        description: leaveRequest.description,
        appliedTo: "System Admin" // Or derive from user's manager
        );
    _mockLeaves.add(newLeave);
    return newLeave;
  }

  // For stats
  int getAvailableLeaves(String userId) => 8; // Mock
  int getApprovedLeavesCount(String userId) => _mockLeaves
      .where((l) => l.userId == userId && l.status == LeaveStatus.approved)
      .length;
  int getPendingLeavesCount(String userId) => _mockLeaves
      .where((l) => l.userId == userId && l.status == LeaveStatus.pending)
      .length;
  int getAppliedLeavesCount(String userId) =>
      _mockLeaves.where((l) => l.userId == userId).length; // Or specific status
  int getRejectedLeavesCount(String userId) => _mockLeaves
      .where((l) => l.userId == userId && l.status == LeaveStatus.rejected)
      .length;
  int getTotalLeaveDaysTakenThisYear(String userId) {
    // TODO: Implement proper calculation for "Total Leave" stat shown in design
    return _mockLeaves
        .where((l) =>
            l.userId == userId &&
            l.status == LeaveStatus.approved &&
            l.startDate.year == DateTime.now().year)
        .fold(0, (sum, item) => sum + item.durationInDays.toInt());
  }
}
