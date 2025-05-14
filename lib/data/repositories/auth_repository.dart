import 'package:algolog/core/constants/app_assets.dart';

import '../models/user_model.dart';

class AuthRepository {
  // Mock current user
  UserModel? currentUser;

  Future<UserModel?> getCurrentUser() async {
    // TODO: API call to get current user session
    await Future.delayed(const Duration(milliseconds: 300));
    return currentUser;
  }

  Future<UserModel> login(String email, String password) async {
    // TODO: API call for login
    await Future.delayed(const Duration(seconds: 1));
    if (email == "test@example.com" && password == "password") {
      currentUser = UserModel(
        id: "user123",
        name: "Robert Joe",
        email: "test@example.com",
        role: "UI/UX Designer",
        profileImageUrl: AppAssets.profilePlaceholder, // Use placeholder path
        dateOfJoining: DateTime(2022, 6, 3),
        employeeId: "21212",
        department: "Some Department Name",
        designation: "Some Designation Name",
        workPhone: "9801234567",
        workEmail: "somename@somemail.com",
        workLocation: "Kupanodl, Kathmandu",
        managerName: "Manager Name",
        contractType: "Salary",
        bankName: "Some Bank",
        accountNumber: "213212312312412",
        branchAddress: "Kathmandu",
        dateOfBirth: DateTime(1990, 8, 17),
        gender: "Male",
        maritalStatus: "Married",
        bloodGroup: "A+",
        nationality: "Nepali",
        address: "Lalitpur",
        nationalId:
            "21213213123123", // Assuming National ID, not 'Identification No'
        fieldOfStudy: "BScCSIT",
        school: "Some School Name",
        emergencyContactName: "Contact Person Name",
        emergencyContactPhone: "9807654321",
        phone: "9801234567", // From personal info screen
      );
      return currentUser!;
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<UserModel> signup(Map<String, dynamic> userData) async {
    // TODO: API call for signup
    await Future.delayed(const Duration(seconds: 1));
    currentUser = UserModel(
      id: "newUser${DateTime.now().millisecondsSinceEpoch}",
      name: userData['name'],
      email: userData['email'],
      phone: userData['phone'],
      dateOfBirth: userData['dateOfBirth'],
      gender: userData['gender'],
      nationalId: userData['nationalId'],
      citizenshipNumber: userData['citizenshipNumber'],
      citizenshipIssueDate: userData['citizenshipIssueDate'],
      role: "New Employee",
    );
    return currentUser!;
  }

  Future<void> logout() async {
    // TODO: API call for logout
    await Future.delayed(const Duration(milliseconds: 300));
    currentUser = null;
  }

  Future<void> forgotPassword(String email) async {
    // TODO: API call for forgot password
    await Future.delayed(const Duration(seconds: 1));
    print("Forgot password request for $email");
  }

  Future<void> resetPassword(String newPassword) async {
    // TODO: API call for reset password (assuming a token is handled elsewhere)
    await Future.delayed(const Duration(seconds: 1));
    print("Password reset to $newPassword");
  }
}
