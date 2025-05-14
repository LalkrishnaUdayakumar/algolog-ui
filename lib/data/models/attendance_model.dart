enum AttendanceType { checkIn, checkOut, breakIn, breakOut }

enum AttendanceStatus { onTime, late, earlyOut }

class AttendanceRecordModel {
  final String id;
  final String userId;
  final DateTime timestamp;
  final AttendanceType type;
  final AttendanceStatus? status; // Status might only apply to check-in/out

  AttendanceRecordModel({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.type,
    this.status,
  });
  // TODO: Add fromJson and toJson methods for API integration
}
