import 'package:flutter/material.dart';
import '../../data/models/leave_model.dart';
import '../../data/repositories/leave_repository.dart';

class LeaveProvider with ChangeNotifier {
  final LeaveRepository _leaveRepository;
  LeaveProvider(this._leaveRepository);

  List<LeaveRequestModel> _leaves = [];
  List<LeaveRequestModel> get leaves => _leaves;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Stats
  int _availableLeaves = 0;
  int get availableLeaves => _availableLeaves;
  int _approvedLeavesCount = 0;
  int get approvedLeavesCount => _approvedLeavesCount;
  int _pendingLeavesCount = 0;
  int get pendingLeavesCount => _pendingLeavesCount;
  int _appliedLeavesCount =
      0; // "Applied" in design, assuming it's total historical
  int get appliedLeavesCount => _appliedLeavesCount;
  int _rejectedLeavesCount = 0;
  int get rejectedLeavesCount => _rejectedLeavesCount;
  int _totalLeaveDaysTaken = 0; // "Total Leave" in design
  int get totalLeaveDaysTaken => _totalLeaveDaysTaken;

  Future<void> fetchLeaves(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _leaves = await _leaveRepository.getLeaveHistory(userId);
      _updateLeaveStats(userId);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> applyForLeave(LeaveRequestModel leaveRequest) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _leaveRepository.applyForLeave(leaveRequest);
      await fetchLeaves(leaveRequest.userId); // Refresh list and stats
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _updateLeaveStats(String userId) {
    _availableLeaves = _leaveRepository.getAvailableLeaves(userId);
    _approvedLeavesCount = _leaveRepository.getApprovedLeavesCount(userId);
    _pendingLeavesCount = _leaveRepository.getPendingLeavesCount(userId);
    _appliedLeavesCount = _leaveRepository.getAppliedLeavesCount(userId);
    _rejectedLeavesCount = _leaveRepository.getRejectedLeavesCount(userId);
    _totalLeaveDaysTaken =
        _leaveRepository.getTotalLeaveDaysTakenThisYear(userId);
  }

  // For Profile Screen stats (monthly)
  int get monthlyLeaves => _leaves
      .where((l) =>
          l.startDate.month == DateTime.now().month &&
          l.startDate.year == DateTime.now().year &&
          l.status == LeaveStatus.approved)
      .length;
}
