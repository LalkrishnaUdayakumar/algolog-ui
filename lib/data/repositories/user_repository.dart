import '../models/user_model.dart';
import 'auth_repository.dart'; // To access the _currentUser for simplicity in mock

class UserRepository {
  final AuthRepository _authRepository;
  UserRepository(this._authRepository);

  Future<UserModel?> getUserDetails(String userId) async {
    // TODO: API call to fetch user details
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, you'd fetch by ID. Here, we use the logged-in user.
    return _authRepository.getCurrentUser();
  }

  Future<UserModel> updateUserDetails(UserModel user) async {
    // TODO: API call to update user details
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you'd update the backend and get the updated model
    // For mock, directly update the one in AuthRepository for demo consistency
    if (_authRepository.currentUser != null &&
        _authRepository.currentUser!.id == user.id) {
      _authRepository.currentUser = user;
    }
    return user;
  }

  // Delete is typically an admin function, but for "deactivate account" for user:
  Future<void> deleteUser(String userId) async {
    // TODO: API call to delete/deactivate user
    await Future.delayed(const Duration(seconds: 1));
    if (_authRepository.currentUser != null &&
        _authRepository.currentUser!.id == userId) {
      _authRepository.currentUser = null; // Simulate deactivation
    }
    print("User $userId deleted/deactivated");
  }
}
