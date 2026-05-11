import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color primaryTextColor = const Color(0xFF6B4C52); // Dark brownish red
  final Color bgColor = const Color(0xFFF9F7F7);
  final Color inputBgColor = const Color(0xFFEAF5EF); // Light mint green

  String _selectedGender = 'Nữ'; // Nữ, Nam, Khác

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/community.jpg'), // placeholder or NetworkImage
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
              'Nguyễn Thanh Xuân',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'HẠNG THÀNH VIÊN: BLOOM',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: primaryTextColor),
            ),
            const SizedBox(height: 32),

            // Form fields
            _buildInputField('Họ và tên', 'Nguyễn Thanh Xuân'),
            const SizedBox(height: 20),

            _buildEmailField('Email', 'thanhxuan@scentie.vn'),
            const SizedBox(height: 20),

            _buildInputField('Số điện thoại', '0901234567', isPhone: true),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('05/20/2002', style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87)),
                      const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black87),
                    ],
                  ),
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
                onPressed: () {},
                icon: const Icon(Icons.save_outlined, size: 20),
                label: Text('Lưu thay đổi', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _buildInputField(String label, String value, {bool isPhone = false}) {
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
          child: TextField(
            controller: TextEditingController(text: value),
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(String label, String value) {
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
                child: Text(value, style: GoogleFonts.outfit(fontSize: 15, color: Colors.grey.shade700)),
              ),
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
              )
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
