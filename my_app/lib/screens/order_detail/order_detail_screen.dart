import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A5E62);
    const Color bgColor = Color(0xFFFAF7F7);
    const Color surfaceColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
              // Order ID & Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Mã đơn hàng', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 8),
              const Text(
                '#SC12345',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Text(
                'Đặt lúc 14:30, 24 Tháng 10, 2024',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Contact Support Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent, size: 18),
                  label: const Text('Liên hệ hỗ trợ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1E8DA),
                    foregroundColor: const Color(0xFF386B52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Timeline
              _buildSectionCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusIcon(Icons.check, 'Đã đặt', true),
                        _buildLine(true),
                        _buildStatusIcon(Icons.receipt_long, 'Đã xác nhận', true),
                        _buildLine(true),
                        _buildStatusIcon(Icons.local_shipping, 'Đang giao', true),
                        _buildLine(false),
                        _buildStatusIcon(Icons.check_circle_outline, 'Hoàn thành', false),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: const Text(
                              'Đơn hàng đang trên đường đến với bạn. Tài xế dự kiến sẽ giao hàng trước 18:00 hôm nay.',
                              style: TextStyle(fontSize: 13, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Selected Products
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, color: primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Sản phẩm đã chọn',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProductItem('Petal Whisper', '10ml', '245.000đ', 'assets/images/petal.jpg', ['Hương Hoa', 'Dịu nhẹ']),
                    const SizedBox(height: 16),
                    _buildProductItem('Urban Dew', '10ml', '210.000đ', 'assets/images/urban.jpg', ['Cỏ', 'Tươi mát']),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Summary
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm tắt thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Tạm tính (2 sản phẩm)', '455.000đ'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Phí vận chuyển', '25.000đ'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Voucher giảm giá', '-30.000đ', valueColor: Colors.green),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Tổng cộng', style: TextStyle(fontSize: 16)),
                        Text(
                          '450.000đ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Phương thức thanh toán', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          Text('Ví MoMo', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Receiver Info
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Người nhận',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('HỌ VÀ TÊN', 'Nguyễn Thanh Xuân'),
                    const SizedBox(height: 12),
                    _buildInfoRow('SỐ ĐIỆN THOẠI', '090 *** 8888'),
                    const SizedBox(height: 12),
                    _buildInfoRow('ĐỊA CHỈ NHẬN HÀNG', 'Ký túc xá khu B, Đại học Quốc gia TP.HCM, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh'),
                    const SizedBox(height: 12),
                    _buildInfoRow('GHI CHÚ', '"Giao vào giờ hành chính, gọi mình trước khi đến nhé!"', isItalic: true),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: const BorderSide(color: Color(0xFFF0D5D8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Thay đổi thông tin'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }

  Widget _buildStatusIcon(IconData icon, String label, bool isActive) {
    const Color primaryColor = Color(0xFF7A5E62);
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? primaryColor : Colors.grey.shade200,
          child: Icon(icon, size: 16, color: isActive ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? primaryColor : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF7A5E62) : Colors.grey.shade200,
      ),
    );
  }

  Widget _buildProductItem(String name, String capacity, String price, String imgUrl, List<String> tags) {
    const Color primaryColor = Color(0xFF7A5E62);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.water_drop, color: Colors.grey), // Placeholder for image
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Text('Dung tích: $capacity', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: tags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEAEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(t, style: const TextStyle(fontSize: 10, color: primaryColor)),
                )).toList(),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            const Text('x1', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF7A5E62),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isItalic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF7A5E62),
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
