import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../../core/widgets/custom_button.dart'; // Using custom button for save

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _nationalityController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _schoolController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;
  // Non-editable for this screen (or handled differently)
  late TextEditingController _emailController;
  late TextEditingController _nationalIdController;

  DateTime? _selectedDateOfBirth;
  String? _selectedGender;
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with data from UserProvider (which should have fetched latest)
    // or fallback to AuthProvider.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final initialUser = userProvider.userDetails ?? authProvider.currentUser;

    if (initialUser != null) {
      _populateControllers(initialUser);
    } else {
      // Handle case where user data is not available (shouldn't happen if routed correctly)
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _addressController = TextEditingController();
      _maritalStatusController = TextEditingController();
      _bloodGroupController = TextEditingController();
      _nationalityController = TextEditingController();
      _fieldOfStudyController = TextEditingController();
      _schoolController = TextEditingController();
      _emergencyContactNameController = TextEditingController();
      _emergencyContactPhoneController = TextEditingController();
      _emailController = TextEditingController();
      _nationalIdController = TextEditingController();
    }
  }

  void _populateControllers(UserModel user) {
    _nameController = TextEditingController(text: user.name);
    _emailController =
        TextEditingController(text: user.email); // Usually not editable
    _phoneController = TextEditingController(text: user.phone ?? '');
    _addressController = TextEditingController(text: user.address ?? '');
    _nationalIdController = TextEditingController(
        text: user.nationalId ?? ''); // Often not editable
    _maritalStatusController =
        TextEditingController(text: user.maritalStatus ?? '');
    _bloodGroupController = TextEditingController(text: user.bloodGroup ?? '');
    _nationalityController =
        TextEditingController(text: user.nationality ?? '');
    _fieldOfStudyController =
        TextEditingController(text: user.fieldOfStudy ?? '');
    _schoolController = TextEditingController(text: user.school ?? '');
    _emergencyContactNameController =
        TextEditingController(text: user.emergencyContactName ?? '');
    _emergencyContactPhoneController =
        TextEditingController(text: user.emergencyContactPhone ?? '');

    _selectedDateOfBirth = user.dateOfBirth;
    _selectedGender = user.gender;
    // Ensure _selectedGender is one of the items in _genders
    if (_selectedGender != null && !_genders.contains(_selectedGender)) {
      _genders.add(_selectedGender!); // Add if not present, or handle default
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nationalIdController.dispose();
    _maritalStatusController.dispose();
    _bloodGroupController.dispose();
    _nationalityController.dispose();
    _fieldOfStudyController.dispose();
    _schoolController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isEditing && !_formKey.currentState!.validate()) {
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context,
        listen: false); // To get current user ID and non-updated fields

    if (authProvider.currentUser == null) return; // Should not happen

    // Create a new UserModel instance with updated values
    // Use copyWith on the existing userDetails from UserProvider or AuthProvider
    // to ensure all fields are preserved and only changed ones are updated.
    final baseUser = userProvider.userDetails ?? authProvider.currentUser!;

    UserModel updatedUser = baseUser.copyWith(
      name: _nameController.text,
      // email: _emailController.text, // Email usually not changed by user this way
      phone: _phoneController.text,
      dateOfBirth: _selectedDateOfBirth,
      gender: _selectedGender,
      // nationalId: _nationalIdController.text, // National ID usually not changed
      address: _addressController.text,
      maritalStatus: _maritalStatusController.text,
      bloodGroup: _bloodGroupController.text,
      nationality: _nationalityController.text,
      fieldOfStudy: _fieldOfStudyController.text,
      school: _schoolController.text,
      emergencyContactName: _emergencyContactNameController.text,
      emergencyContactPhone: _emergencyContactPhoneController.text,
    );

    // TODO: API Call: Update user details
    bool success = await userProvider.updateUserDetails(updatedUser);

    if (success && mounted) {
      // UserProvider's userDetails should now be updated.
      // If AuthProvider.currentUser is also used for display, it needs to be kept in sync.
      // A cleaner way would be for AuthProvider to listen to UserProvider for changes
      // or to have a method to refresh its own user data.
      // For now, we assume UserProvider's data is the primary source for this screen post-update.
      if (userProvider.userDetails != null) {
        authProvider.updateInternalCurrentUser(userProvider.userDetails);
      } // Simple sync for mock

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Information updated successfully!"),
            backgroundColor: AppColors.green),
      );
      setState(() => _isEditing = false);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                userProvider.errorMessage ?? "Failed to update information."),
            backgroundColor: AppColors.red),
      );
    }
  }

  void _cancelEdit() {
    // Repopulate controllers with original data before canceling
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final originalUser = userProvider.userDetails ?? authProvider.currentUser;
    if (originalUser != null) {
      _populateControllers(originalUser);
    }
    setState(() => _isEditing = false);
  }

  Future<void> _pickDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Optional: Theme the DatePicker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer will rebuild parts of the UI when UserProvider notifies listeners
    return Consumer<UserProvider>(builder: (context, userProv, child) {
      // Use userProv.userDetails first, fallback to authUser if userDetails is null (e.g., initial load)
      final authUser =
          Provider.of<AuthProvider>(context, listen: false).currentUser;
      final displayUser = userProv.userDetails ?? authUser;

      if (displayUser == null) {
        return Scaffold(
            appBar: AppBar(title: const Text("Personal Information")),
            body: const Center(child: CircularProgressIndicator()));
      }
      // If not editing, ensure controllers reflect the latest displayUser data
      // This handles cases where UserProvider updates from somewhere else.
      if (!_isEditing) {
        _populateControllers(displayUser);
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text("Personal Information"),
          actions: [
            if (!_isEditing)
              TextButton(
                onPressed: () => setState(() => _isEditing = true),
                child: const Text("Edit",
                    style: TextStyle(color: AppColors.white, fontSize: 16)),
              )
            else ...[
              IconButton(
                  icon:
                      const Icon(Icons.cancel_outlined, color: AppColors.white),
                  tooltip: "Cancel Edit",
                  onPressed: _cancelEdit),
              IconButton(
                  icon: const Icon(Icons.save_alt_outlined,
                      color: AppColors.white),
                  tooltip: "Save Changes",
                  onPressed: userProv.isLoading
                      ? null
                      : _saveChanges), // Disable save if loading
            ]
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("General Info", style: AppTextStyles.heading3),
                const SizedBox(height: AppDimens.paddingSmall),
                _buildInfoField(
                    label: "Full Name",
                    controller: _nameController,
                    isEditing: _isEditing,
                    validator: (val) =>
                        val!.isEmpty ? "Name cannot be empty" : null),
                _buildInfoField(
                    label: "Phone Number",
                    controller: _phoneController,
                    isEditing: _isEditing,
                    keyboardType: TextInputType.phone),
                _buildInfoField(
                    label: "Email",
                    controller: _emailController,
                    isEditing: false,
                    enabled: false),
                _buildDateField(
                    label: "Date of Birth",
                    selectedDate: _selectedDateOfBirth,
                    isEditing: _isEditing,
                    onTap: _pickDateOfBirth),
                _buildDropdownField(
                    label: "Gender",
                    currentValue: _selectedGender,
                    items: _genders,
                    isEditing: _isEditing,
                    onChanged: (val) => setState(() => _selectedGender = val)),
                _buildInfoField(
                    label: "Marital Status",
                    controller: _maritalStatusController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "Blood Group",
                    controller: _bloodGroupController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "Nationality",
                    controller: _nationalityController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "Address",
                    controller: _addressController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "Identification No (National ID)",
                    controller: _nationalIdController,
                    isEditing: false,
                    enabled: false),
                _buildInfoField(
                    label: "Field of Study",
                    controller: _fieldOfStudyController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "School",
                    controller: _schoolController,
                    isEditing: _isEditing),
                const SizedBox(height: AppDimens.paddingMedium),
                const Text("Emergency Contact", style: AppTextStyles.heading3),
                const SizedBox(height: AppDimens.paddingSmall),
                _buildInfoField(
                    label: "Contact Person Name",
                    controller: _emergencyContactNameController,
                    isEditing: _isEditing),
                _buildInfoField(
                    label: "Emergency Phone",
                    controller: _emergencyContactPhoneController,
                    isEditing: _isEditing,
                    keyboardType: TextInputType.phone),
                if (userProv.isLoading && _isEditing) ...[
                  // Show loading only when saving
                  const SizedBox(height: AppDimens.paddingMedium),
                  const Center(child: CircularProgressIndicator()),
                ] else if (_isEditing) ...[
                  // Show save button only in edit mode and not loading
                  const SizedBox(height: AppDimens.paddingLarge),
                  CustomButton(
                    text: "Save Changes",
                    onPressed: _saveChanges,
                    isLoading: userProv.isLoading,
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    bool isEditing = false,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall / 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.bodyTextSmall
                  .copyWith(color: AppColors.greyText)),
          const SizedBox(height: 4),
          isEditing && enabled
              ? TextFormField(
                  controller: controller,
                  style: AppTextStyles.bodyTextLarge,
                  keyboardType: keyboardType,
                  validator: validator,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingSmall,
                        horizontal: AppDimens.paddingSmall / 2),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary)),
                    filled: false, // No fill for underline style
                    fillColor: Colors.transparent,
                  ),
                )
              : Text(controller.text.isNotEmpty ? controller.text : "-",
                  style: AppTextStyles.bodyTextLarge
                      .copyWith(fontWeight: FontWeight.w500)),
          if (!isEditing || !enabled)
            const Divider(height: AppDimens.paddingSmall, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required bool isEditing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall / 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.bodyTextSmall
                  .copyWith(color: AppColors.greyText)),
          const SizedBox(height: 4),
          isEditing
              ? InkWell(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity, // Make it take full width for tap
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingSmall + 2,
                        horizontal: AppDimens.paddingSmall / 2),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.darkGreyText, width: 0.8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormatter.formatToddMMyyyy(selectedDate)
                              : "Select Date",
                          style: AppTextStyles.bodyTextLarge,
                        ),
                        const Icon(Icons.calendar_today_outlined,
                            size: 20, color: AppColors.greyText),
                      ],
                    ),
                  ),
                )
              : Text(
                  selectedDate != null
                      ? DateFormatter.formatToddMMyyyy(selectedDate)
                      : "-",
                  style: AppTextStyles.bodyTextLarge
                      .copyWith(fontWeight: FontWeight.w500),
                ),
          if (!isEditing)
            const Divider(height: AppDimens.paddingSmall, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? currentValue,
    required List<String> items,
    required bool isEditing,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall / 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.bodyTextSmall
                  .copyWith(color: AppColors.greyText)),
          // SizedBox(height: 4), // Removed for tighter alignment with DropdownButtonFormField
          isEditing
              ? DropdownButtonFormField<String>(
                  value: currentValue,
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: onChanged,
                  style: AppTextStyles.bodyTextLarge,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(
                        AppDimens.paddingSmall / 2,
                        AppDimens.paddingSmall,
                        AppDimens.paddingSmall / 2,
                        AppDimens.paddingSmall / 1.5),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary)),
                    filled: false,
                    fillColor: Colors.transparent,
                  ),
                  validator: (value) =>
                      value == null ? 'Please select an option' : null,
                )
              : Text(
                  currentValue ?? "-",
                  style: AppTextStyles.bodyTextLarge
                      .copyWith(fontWeight: FontWeight.w500),
                ),
          if (!isEditing)
            const Divider(height: AppDimens.paddingSmall, thickness: 0.5),
        ],
      ),
    );
  }
}
