import '../models/attendance_model.dart';

class AttendanceRepository {
  final List<AttendanceRecordModel> _mockAttendance = [
    AttendanceRecordModel(
        id: "att1",
        userId: "user123",
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        type: AttendanceType.breakIn),
    AttendanceRecordModel(
        id: "att2",
        userId: "user123",
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: AttendanceType.checkIn,
        status: AttendanceStatus.onTime),
  ];

  Future<List<AttendanceRecordModel>> getAttendanceHistory(
      String userId, DateTime date) async {
    // TODO: API call to get attendance for a specific date
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAttendance
        .where((att) =>
            att.userId == userId &&
            att.timestamp.year == date.year &&
            att.timestamp.month == date.month &&
            att.timestamp.day == date.day)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort descending
  }

  Future<AttendanceRecordModel> punchIn(String userId) async {
    // TODO: API call to punch in
    await Future.delayed(const Duration(milliseconds: 300));
    final record = AttendanceRecordModel(
      id: "attNew${DateTime.now().millisecondsSinceEpoch}",
      userId: userId,
      timestamp: DateTime.now(),
      type: AttendanceType.checkIn,
      status: AttendanceStatus.onTime, // Logic for late can be added
    );
    _mockAttendance.add(record);
    return record;
  }

  Future<AttendanceRecordModel> punchOut(String userId) async {
    // TODO: API call to punch out
    await Future.delayed(const Duration(milliseconds: 300));
    final record = AttendanceRecordModel(
      id: "attNew${DateTime.now().millisecondsSinceEpoch}",
      userId: userId,
      timestamp: DateTime.now(),
      type: AttendanceType.checkOut,
    );
    _mockAttendance.add(record);
    return record;
  }
}
