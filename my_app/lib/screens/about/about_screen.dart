import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A5E62);
    const Color bgColor = Color(0xFFFAF7F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: primaryColor),
          onPressed: () {},
        ),
        title: const Text(
          'Scentie',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEAEB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'CÂU CHUYỆN SCENTIE',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Mang hương thơm\nthanh xuân đến gần\nbạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Scentie không chỉ bán nước hoa, chúng mình còn mong muốn là người bạn mang thông điệp yêu thương, biến mỗi hành trình màng một mùi hương cao cấp trở nên gần gũi và tinh tế hơn cho các bạn sinh viên Việt Nam.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Buttons
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Khám phá ngay'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: Color(0xFFE5DADA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Tìm hiểu hương thơm'),
            ),
            const SizedBox(height: 32),
            
            // Big Image placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEAEB),
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/perfume_hero.png'), // placeholder
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.water_drop, size: 64, color: primaryColor.withOpacity(0.5)),
                ),
              ),
            ),
            const SizedBox(height: 48),
            
            // Divider text
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 40, child: Divider(color: Color(0xFFF0D5D8), thickness: 2)),
                SizedBox(width: 16),
                Text('Sứ mệnh & Giá trị', style: TextStyle(color: Colors.black54, fontSize: 12)),
                SizedBox(width: 16),
                SizedBox(width: 40, child: Divider(color: Color(0xFFF0D5D8), thickness: 2)),
              ],
            ),
            const SizedBox(height: 32),
            
            // Card 1
            _buildInfoCard(
              context: context,
              icon: Icons.verified_user_outlined,
              iconBgColor: const Color(0xFFFDEAEB),
              iconColor: primaryColor,
              title: '100% Authentic Cam kết',
              desc: 'Tại Scentie, chúng mình nói không với hàng giả. Từng chai nước hoa chính hãng được chiết xuất trực tiếp từ chai gốc chính hãng dưới quy trình nghiêm ngặt, đảm bảo vẹn nguyên bản sắc và tông hương của nhà sản xuất.',
              showLink: true,
            ),
            
            // Card 2
            _buildInfoCard(
              context: context,
              icon: Icons.attach_money,
              iconBgColor: const Color(0xFFF4F3FF),
              iconColor: const Color(0xFF5A52A5),
              title: 'Giá thành cực kì hợp lý',
              desc: 'Mua hương xa xỉ giờ đây không còn quá tầm với. Với các dung tích chiết 2ml, 5ml, 10ml, bạn có thể dễ dàng trải nghiệm hàng chục mùi hương nổi tiếng với chi phí rẻ hơn một nửa bữa ăn.',
            ),
            
            const SizedBox(height: 16),
            const Text(
              'L O V E S T I O N',
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            
            // Card 3
            _buildInfoCard(
              context: context,
              icon: Icons.favorite_border,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: Colors.green,
              title: 'Đóng gói xinh xắn',
              desc: 'Mỗi đơn hàng từ Scentie là một món quà dành cho chính bạn. Hộp quà pastel, sticker trang trí và thiệp nhắn sẻ chia, sẽ làm ngày của bạn trở nên ngọt ngào hơn bao giờ hết.',
            ),
            
            // Card 4
            _buildInfoCard(
              context: context,
              icon: Icons.group_outlined,
              iconBgColor: Colors.transparent,
              iconColor: Colors.transparent,
              title: 'Cộng đồng yêu hương',
              desc: 'Scentie không chỉ là một cửa hàng, mà là nơi chúng mình cùng nhau chia sẻ về kiến thức nước hoa, cách chọn mùi theo tính cách và những câu chuyện về phong cách sống của Gen Z.',
              hasImage: true,
            ),
            
            const SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 40, child: Divider(color: Color(0xFFF0D5D8), thickness: 2)),
                SizedBox(width: 16),
                Text('Bảng mùi hương thơm', style: TextStyle(color: Colors.black54, fontSize: 12)),
                SizedBox(width: 16),
                SizedBox(width: 40, child: Divider(color: Color(0xFFF0D5D8), thickness: 2)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildTag('Hương Hoa (Floral)', const Color(0xFFFFF0F5), const Color(0xFFD4819B)),
                _buildTag('Hương Gỗ (Woody)', const Color(0xFFE8F5E9), const Color(0xFF6B9B74)),
                _buildTag('Trái Cây (Fruity)', const Color(0xFFF3E5F5), const Color(0xFF9C6BB5)),
                _buildTag('Rễ Phức (Chypre)', const Color(0xFFFDEAEB), primaryColor),
                _buildTag('Cỏ (Aromatic)', const Color(0xFFEFEFEF), Colors.grey.shade700),
              ],
            ),
            
            const SizedBox(height: 48),
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              color: bgColor,
              child: Column(
                children: [
                  const Text(
                    'Scentie',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nơi hương thơm thanh xuân đến gần\nvà sẻ chia chuyện thanh xuân của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Về\nchúng\ntôi', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                      Text('Chính\nsách\nbảo mật', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                      Text('Liên\nhệ', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('© 2024 Scentie - Mùi Hương Thanh Xuân', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 32), // space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String desc,
    bool showLink = false,
    bool hasImage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != Icons.group_outlined)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            if (icon != Icons.group_outlined)
              const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A5E62),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            if (showLink) ...[
              const SizedBox(height: 16),
              Row(
                children: const [
                  Text('TÌM HIỂU VỀ QUY TRÌNH CHIẾT', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              )
            ],
            if (hasImage) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.share_outlined, size: 20, color: Color(0xFF7A5E62)),
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline, size: 20, color: Color(0xFF7A5E62)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/community.jpg'), // placeholder
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(child: Icon(Icons.groups, color: Colors.grey, size: 48)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
