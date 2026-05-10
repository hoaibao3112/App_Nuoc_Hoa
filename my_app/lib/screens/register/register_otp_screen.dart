import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterOTPScreen extends StatelessWidget {
  const RegisterOTPScreen({super.key});

  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFE8C3C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scentie',
          style: GoogleFonts.outfit(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: primaryTextColor),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFDEAEB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // OTP Card
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.mark_email_unread_outlined, size: 40, color: primaryTextColor),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Xác thực Email',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Chúng tôi đã gửi mã OTP đến email của bạn. Vui lòng kiểm tra hộp thư đến.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: primaryTextColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // OTP Inputs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) => _buildOTPField()),
                      ),
                      const SizedBox(height: 50),
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register_password');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D6E63),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Bạn chưa nhận được mã?',
                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, size: 16),
                        label: Text(
                          'Gửi lại mã',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Footer security
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSecurityInfo(Icons.verified_user_outlined, 'Bảo mật 100%'),
                    const SizedBox(width: 30),
                    _buildSecurityInfo(Icons.headset_mic_outlined, 'Hỗ trợ 24/7'),
                  ],
                ),
                const SizedBox(height: 80),
                Text(
                  '© 2024 Scentie - Mùi hương thanh xuân.',
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F9),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
