import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final Color primaryColor = const Color(0xFF4A3434);
  final Color secondaryColor = const Color(0xFF8B5E66);
  final Color backgroundColor = const Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Hỗ trợ & Liên hệ',
          style: GoogleFonts.outfit(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined, color: primaryColor),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Gửi chút hương, nhận\nphản hồi',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scentie luôn ở đây để lắng nghe những thắc mắc và góp ý của bạn về thế giới mùi hương thanh xuân.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: secondaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Contact Cards
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: 'Hotline',
              value: '0374170367',
              subtitle: 'Hỗ trợ từ 8:00 - 21:00',
              iconColor: const Color(0xFFF9A8D4),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.mail_outline,
              title: 'Email',
              value: 'baohoaitran3112@gmail.com',
              subtitle: 'Phản hồi trong vòng 24h',
              iconColor: const Color(0xFF99F6E4),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.location_on_outlined,
              title: 'Văn phòng',
              value: '123 Xuân Thủy, Cầu Giấy, Hà Nội',
              subtitle: 'Ghé thăm showroom của chúng mình',
              iconColor: const Color(0xFFC7D2FE),
            ),

            const SizedBox(height: 40),

            // FAQ Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: Color(0xFF8B5E66)),
                  const SizedBox(width: 8),
                  Text(
                    'Câu hỏi thường gặp',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FAQ Expansion Tiles
            _buildFAQTile(
              'Làm thế nào để chọn được mùi hương phù hợp?',
              'Bạn có thể tham khảo bảng nốt hương chi tiết ở mỗi sản phẩm hoặc sử dụng công cụ "AI Scent Finder" để tìm ra mùi hương chân ái dựa trên cá tính và sở thích cá nhân của mình nhé!',
              initiallyExpanded: true,
            ),
            _buildFAQTile(
              'Chính sách đổi trả sản phẩm như thế nào?',
              'Scentie hỗ trợ đổi trả trong vòng 7 ngày nếu sản phẩm còn nguyên tem mác và có lỗi từ nhà sản xuất.',
            ),
            _buildFAQTile(
              'Thời gian giao hàng là bao lâu?',
              'Nội thành Hà Nội & TP.HCM từ 1-2 ngày, các tỉnh thành khác từ 3-5 ngày làm việc.',
            ),

            const SizedBox(height: 24),

            // Support Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const Text(
                    'Vẫn cần hỗ trợ thêm?',
                    style: TextStyle(color: Color(0xFF8B5E66), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đội ngũ Scentie luôn sẵn sàng hỗ trợ các bạn Gen-Z 24/7 qua các kênh mạng xã hội Instagram và TikTok nữa đó!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8B5E66), fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1595428774223-ef52624120d2?w=500&q=80',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Leave a message form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Để lại lời nhắn',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scentie sẽ liên hệ lại với bạn sớm nhất qua email nhé!',
                    style: TextStyle(color: secondaryColor, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(label: 'Họ và tên', hint: 'Nguyễn Văn A'),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Email', hint: 'example@gmail.com'),
                  const SizedBox(height: 16),
                  _buildDropdownField(label: 'Chủ đề', value: 'Tư vấn mùi hương'),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Nội dung tin nhắn', hint: 'Chia sẻ với Scentie thắc mắc của bạn nhé...', maxLines: 4),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD1DC), Color(0xFFE6E6FA)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Gửi lời nhắn ngay',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Footer Section
            Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFF3F4F6),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scentie',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mang đến những nốt hương tinh khôi, lưu giữ khoảnh khắc thanh xuân tươi đẹp nhất của bạn qua từng giọt nước hoa.',
                    style: TextStyle(color: secondaryColor, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFooterColumn('Thông tin', ['Về chúng tôi', 'Chính sách bảo mật']),
                      _buildFooterColumn('Liên kết', ['Điều khoản sử dụng', 'Liên hệ']),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      '© 2026 Scentie - Mùi hương thanh xuân',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: secondaryColor),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: secondaryColor.withOpacity(0.6), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: secondaryColor.withOpacity(0.5), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String title, String content, {bool initiallyExpanded = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
        ),
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            content,
            style: TextStyle(color: secondaryColor, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
              items: [value].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: primaryColor, fontSize: 14)),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(item, style: TextStyle(color: secondaryColor, fontSize: 12)),
            )),
      ],
    );
  }
}
