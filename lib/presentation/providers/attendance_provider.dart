import 'package:flutter/material.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import 'dart:async';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _attendanceRepository;
  AttendanceProvider(this._attendanceRepository);

  List<AttendanceRecordModel> _todayAttendance = [];
  List<AttendanceRecordModel> get todayAttendance => _todayAttendance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Timer for punch-in duration (example)
  Timer? _workTimer;
  Duration _currentWorkDuration = Duration.zero;
  Duration get currentWorkDuration => _currentWorkDuration;
  DateTime? _lastPunchInTime;

  bool get isPunchedIn => _todayAttendance.any((att) =>
      att.type == AttendanceType.checkIn &&
      !_todayAttendance.any((outAtt) =>
          outAtt.type == AttendanceType.checkOut &&
          outAtt.timestamp.isAfter(att.timestamp)));

  Future<void> fetchTodayAttendance(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    // No need to notify listeners here, as UI might not be built yet or it's a background fetch
    try {
      _todayAttendance = await _attendanceRepository.getAttendanceHistory(
          userId, DateTime.now());
      _updateWorkTimerState();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners(); // Notify after all operations
  }

  Future<bool> punchIn(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final record = await _attendanceRepository.punchIn(userId);
      _todayAttendance.add(record);
      _todayAttendance.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _updateWorkTimerState();
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

  Future<bool> punchOut(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final record = await _attendanceRepository.punchOut(userId);
      _todayAttendance.add(record);
      _todayAttendance.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _updateWorkTimerState(); // This will stop the timer
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

  void _updateWorkTimerState() {
    _workTimer?.cancel();
    _currentWorkDuration = Duration.zero;

    final checkInRecords = _todayAttendance
        .where((att) => att.type == AttendanceType.checkIn)
        .toList();
    checkInRecords
        .sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Oldest first

    final checkOutRecords = _todayAttendance
        .where((att) => att.type == AttendanceType.checkOut)
        .toList();
    checkOutRecords.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (checkInRecords.isNotEmpty) {
      DateTime lastCheckIn = checkInRecords.last.timestamp;
      bool currentlyCheckedIn = true;

      if (checkOutRecords.isNotEmpty &&
          checkOutRecords.last.timestamp.isAfter(lastCheckIn)) {
        currentlyCheckedIn = false; // Last action was a checkout
      }

      // Calculate total worked duration based on pairs
      // This is simplified. A real system would handle breaks, multiple punch-ins/outs.
      // For now, let's just calculate from the very first check-in to the very last check-out if present.
      // Or from first check-in to now if still checked in.

      DateTime effectiveStartTime = checkInRecords.first.timestamp;
      DateTime effectiveEndTime = DateTime.now();

      if (!currentlyCheckedIn && checkOutRecords.isNotEmpty) {
        effectiveEndTime = checkOutRecords.last.timestamp;
        _currentWorkDuration = effectiveEndTime.difference(effectiveStartTime);
      } else if (currentlyCheckedIn) {
        _lastPunchInTime = lastCheckIn; // Store the most recent punch-in
        _currentWorkDuration = DateTime.now().difference(_lastPunchInTime!);
        _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _currentWorkDuration = DateTime.now().difference(_lastPunchInTime!);
          notifyListeners();
        });
      }
    }
    notifyListeners();
  }

  // For Profile Screen stats (monthly)
  int get monthlyAttendanceDays {
    // TODO: API call or more complex logic to get monthly attendance days
    return 20; // Mock
  }

  int get monthlyHoursWorked {
    // TODO: API call or more complex logic
    return 160; // Mock
  }

  int get monthlyLateCount {
    // TODO: API call or more complex logic
    return 2; // Mock
  }

  @override
  void dispose() {
    _workTimer?.cancel();
    super.dispose();
  }
}
