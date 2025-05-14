class UserModel {
  final String id;
  String name;
  String email;
  String? phone;
  DateTime? dateOfBirth;
  String? gender;
  String? nationalId;
  String? citizenshipNumber;
  DateTime? citizenshipIssueDate;
  String role;

  String? employeeId;
  DateTime? dateOfJoining;
  String? department;
  String? designation;
  String? workPhone;
  String? workEmail;
  String? workLocation;
  String? managerName;
  String? contractType;

  String? bankName;
  String? accountNumber;
  String? branchAddress;

  String? maritalStatus;
  String? bloodGroup;
  String? nationality;
  String? address;
  String? fieldOfStudy;
  String? school;
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.nationalId,
    this.citizenshipNumber,
    this.citizenshipIssueDate,
    this.role = "Employee",
    this.employeeId,
    this.dateOfJoining,
    this.department,
    this.designation,
    this.workPhone,
    this.workEmail,
    this.workLocation,
    this.managerName,
    this.contractType,
    this.bankName,
    this.accountNumber,
    this.branchAddress,
    this.maritalStatus,
    this.bloodGroup,
    this.nationality,
    this.address,
    this.fieldOfStudy,
    this.school,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.profileImageUrl,
  });

  // TODO: Add fromJson and toJson methods for API integration

  // copyWith method directly inside the class
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? nationalId,
    String? citizenshipNumber,
    DateTime? citizenshipIssueDate,
    String? role,
    String? employeeId,
    DateTime? dateOfJoining,
    String? department,
    String? designation,
    String? workPhone,
    String? workEmail,
    String? workLocation,
    String? managerName,
    String? contractType,
    String? bankName,
    String? accountNumber,
    String? branchAddress,
    String? maritalStatus,
    String? bloodGroup,
    String? nationality,
    String? address,
    String? fieldOfStudy,
    String? school,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationalId: nationalId ?? this.nationalId,
      citizenshipNumber: citizenshipNumber ?? this.citizenshipNumber,
      citizenshipIssueDate: citizenshipIssueDate ?? this.citizenshipIssueDate,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      workPhone: workPhone ?? this.workPhone,
      workEmail: workEmail ?? this.workEmail,
      workLocation: workLocation ?? this.workLocation,
      managerName: managerName ?? this.managerName,
      contractType: contractType ?? this.contractType,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      branchAddress: branchAddress ?? this.branchAddress,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      school: school ?? this.school,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
