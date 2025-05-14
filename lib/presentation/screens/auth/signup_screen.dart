import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _citizenshipNumberController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  DateTime? _selectedCitizenshipIssueDate;
  String? _selectedGender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  Future<void> _selectDate(BuildContext context, bool isDOB) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDOB) {
          _selectedDateOfBirth = picked;
        } else {
          _selectedCitizenshipIssueDate = picked;
        }
      });
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Date of Birth')),
      );
      return;
    }
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Gender')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'dateOfBirth': _selectedDateOfBirth,
      'gender': _selectedGender,
      'nationalId': _nationalIdController.text.trim(),
      'citizenshipNumber': _citizenshipNumberController.text.trim(),
      'citizenshipIssueDate': _selectedCitizenshipIssueDate,
    };

    bool success = await authProvider.signup(userData);

    if (success && mounted) {
      // Navigate to a confirmation screen or directly to home
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.mainWrapperRoute, (route) => false);
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome! Register your account to get started with hr app',
                style: AppTextStyles.bodyTextMedium
                    .copyWith(color: AppColors.greyText),
              ),
              const SizedBox(height: AppDimens.paddingLarge),
              _buildTextField(
                controller: _nameController,
                labelText: 'Your name',
                prefixIcon: Icons.person_outline,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Phone',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildDateField("Select Date of Birth", _selectedDateOfBirth,
                  () => _selectDate(context, true)),
              _buildDropdownField("Select Gender", _selectedGender, _genders,
                  (val) {
                setState(() => _selectedGender = val);
              }),
              _buildTextField(
                controller: _nationalIdController,
                labelText: 'National ID',
                prefixIcon: Icons.badge_outlined,
              ),
              _buildTextField(
                controller: _citizenshipNumberController,
                labelText: 'Citizenship Number',
                prefixIcon: Icons.subtitles_outlined,
              ),
              _buildDateField(
                  "Citizenship Issue Date",
                  _selectedCitizenshipIssueDate,
                  () => _selectDate(context, false)),
              const SizedBox(height: AppDimens.paddingLarge),
              authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        child: const Text('Create Account'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.greyText)
              : null,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? selectedDate, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.calendar_today_outlined,
                color: AppColors.greyText),
          ),
          child: Text(
            selectedDate != null
                ? DateFormatter.formatToddMMyyyy(selectedDate)
                : 'Select Date',
            style: selectedDate != null
                ? AppTextStyles.bodyTextMedium
                : AppTextStyles.bodyTextMedium
                    .copyWith(color: AppColors.greyText),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? currentValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.wc_outlined,
              color: AppColors.greyText), // Example icon
        ),
        value: currentValue,
        hint: Text('Select $label',
            style: AppTextStyles.bodyTextMedium
                .copyWith(color: AppColors.greyText)),
        isExpanded: true,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select an option' : null,
      ),
    );
  }
}
