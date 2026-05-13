import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color primaryTextColor = const Color(0xFF6B4C52); // Dark brownish red
  final Color bgColor = const Color(0xFFF9F7F7);
  final Color inputBgColor = const Color(0xFFEAF5EF); // Light mint green
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = true;
  bool _isSaving = false;

  String _selectedGender = '';
  DateTime? _birthDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await _authService.getProfile();
    if (!mounted) return;

    _currentUser = profile;
    _nameController.text = profile?.name ?? '';
    _emailController.text = profile?.email ?? '';
    _phoneController.text = profile?.phone ?? '';
    _selectedGender = profile?.gender ?? '';
    _birthDate = _parseDate(profile?.birthDate);
    _birthDateController.text = _birthDate != null ? DateFormat('dd/MM/yyyy').format(_birthDate!) : '';

    setState(() {
      _isLoading = false;
    });
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickBirthDate() async {
    final initialDate = _birthDate ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = <String, dynamic>{};
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isNotEmpty) data['fullName'] = name;
    if (phone.isNotEmpty) data['phone'] = phone;
    if (_selectedGender.isNotEmpty) data['gender'] = _selectedGender;
    if (_birthDate != null) data['birthDate'] = _birthDate!.toIso8601String();

    setState(() => _isSaving = true);
    try {
      final updated = await _authService.updateProfile(data);
      if (!mounted) return;

      if (updated != null) {
        setState(() {
          _currentUser = updated;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu thông tin tài khoản')),
        );
      } else {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thất bại. Vui lòng thử lại.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi khi lưu thông tin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final avatarUrl = _currentUser?.avatarUrl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông tin tài khoản',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFF0F0F0),
                        backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: (avatarUrl == null || avatarUrl.isEmpty)
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6B4C52),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Name & Rank
              Text(
                _currentUser?.name ?? '',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                _currentUser?.rank.isNotEmpty == true ? 'HẠNG THÀNH VIÊN: ${_currentUser!.rank.toUpperCase()}' : '',
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: primaryTextColor),
              ),
              const SizedBox(height: 32),

              // Form fields
              _buildInputField(
                label: 'Họ và tên',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  if (value.trim().length < 2) return 'Họ và tên quá ngắn';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildEmailField(
                label: 'Email',
                controller: _emailController,
                readOnly: true,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: 'Số điện thoại',
                controller: _phoneController,
                isPhone: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final normalized = value.replaceAll(RegExp(r'\s+'), '');
                  final isValid = RegExp(r'^(0|\+84)\d{9}$').hasMatch(normalized) || RegExp(r'^\d{9,11}$').hasMatch(normalized);
                  return isValid ? null : 'Số điện thoại không hợp lệ';
                },
              ),
              const SizedBox(height: 20),

              // Gender
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giới tính', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGenderOption('Nữ', Icons.female),
                      const SizedBox(width: 12),
                      _buildGenderOption('Nam', Icons.male),
                      const SizedBox(width: 12),
                      _buildGenderOption('Khác', null),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Birthday
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ngày sinh', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _pickBirthDate,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: inputBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black87),
                    ),
                    style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Change Password
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.history, color: primaryTextColor, size: 18),
                label: Text('Đổi mật khẩu', style: GoogleFonts.outfit(color: primaryTextColor, fontSize: 14)),
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: const Icon(Icons.save_outlined, size: 20),
                  label: Text(
                    _isSaving ? 'Đang lưu...' : 'Lưu thay đổi',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTextColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPhone = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            validator: validator,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField({
    required String label,
    required TextEditingController controller,
    required bool readOnly,
  }) {
    final hasEmail = controller.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // slightly different grey for disabled feeling
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.outfit(fontSize: 15, color: Colors.grey.shade700),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final isValid = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim());
                    return isValid ? null : 'Email không hợp lệ';
                  },
                ),
              ),
              if (hasEmail)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8F2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: 12, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 4),
                      Text('ĐÃ XÁC THỰC', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String text, IconData? icon) {
    final bool isSelected = _selectedGender == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFDEAEB) : Colors.transparent,
            border: Border.all(color: isSelected ? const Color(0xFFF0D5D8) : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: isSelected ? primaryTextColor : Colors.grey.shade600),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primaryTextColor : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
