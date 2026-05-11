import 'package:flutter/material.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MY WALLET',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ví Voucher & Ưu đãi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chào cậu, hôm nay hãy để Scentie mang hương thơm thanh xuân đến gần cậu hơn nhé!',
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildSummaryCard(
                      'Vouchers Sẵn Có',
                      '03',
                      Icons.local_activity_outlined,
                      const Color(0xFFFFF5F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Điểm Thưởng',
                      '850',
                      Icons.stars_outlined,
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Hạng Thành Viên',
                      'Bạc',
                      Icons.military_tech_outlined,
                      const Color(0xFFF4FAFC),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Vouchers List
              _buildVoucherCard(
                icon: Icons.school_outlined,
                title: '10% OFF',
                headerColor: const Color(0xFFFFF5F6),
                desc: 'Giảm 10% cho sinh viên',
                code: 'SCENTESTUDENT',
                codeColor: const Color(0xFFFDEAEB),
                expiry: '31/12/2024',
                condition: 'Áp dụng cho mọi đơn hàng khi xuất trình thẻ sinh viên hoặc email .edu',
                btnColor: const Color(0xFF7A5E62),
              ),
              const SizedBox(height: 16),
              _buildVoucherCard(
                icon: Icons.local_shipping_outlined,
                title: '0 VNĐ',
                headerColor: const Color(0xFFF2F9F5),
                desc: 'Free Ship đơn 200k',
                code: 'FREESHIP200',
                codeColor: const Color(0xFFD1E8DA),
                expiry: '15/11/2024',
                condition: 'Miễn phí vận chuyển nội thành cho đơn hàng từ 200.000đ.',
                btnColor: const Color(0xFF50685A),
              ),
              const SizedBox(height: 16),
              _buildVoucherCard(
                icon: Icons.card_giftcard_outlined,
                title: 'GIFT',
                headerColor: const Color(0xFFF6F6FA),
                desc: 'Tặng mẫu thử cho đơn đầu',
                code: 'NEWBIESCENT',
                codeColor: const Color(0xFFE5E5F0),
                expiry: 'Vĩnh viễn',
                condition: 'Tặng kèm 01 vial nước hoa 2ml tùy chọn cho khách hàng lần đầu mua sắm.',
                btnColor: const Color(0xFF646473),
              ),
              const SizedBox(height: 24),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF8D6E73), // A soft mauve color
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Gom đơn - Nhận quà',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Giảm thêm 50k cho đơn hàng rủ bạn mua chung từ 500k!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8D6E73),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Tìm hiểu thêm', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF7A5E62),
                ),
              ),
              Icon(icon, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard({
    required IconData icon,
    required String title,
    required Color headerColor,
    required String desc,
    required String code,
    required Color codeColor,
    required String expiry,
    required String condition,
    required Color btnColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: btnColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: btnColor,
                  ),
                ),
              ],
            ),
          ),
          // Divider (dashed look)
          Container(
            height: 2,
            color: Colors.white, // Actually in a real app you'd use a dashed line painter
          ),
          // Bottom section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: codeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        code,
                        style: TextStyle(fontSize: 10, color: btnColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('HSD: $expiry', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  condition,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Dùng ngay'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
