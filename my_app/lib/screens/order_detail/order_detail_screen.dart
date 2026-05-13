import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart' as model;
import '../../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderService _orderService = OrderService();
  model.Order? _order;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orderId = ModalRoute.of(context)?.settings.arguments as String?;
    if (orderId != null) {
      _fetchOrderDetails(orderId);
    }
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    try {
      final orders = await _orderService.getOrders();
      final order = orders.firstWhere((o) => o.id == orderId);
      if (mounted) {
        setState(() {
          _order = order;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A5E62);
    const Color bgColor = Color(0xFFFAF7F7);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('HH:mm, dd/MM/yyyy');

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
        body: const Center(child: Text('Không tìm thấy thông tin đơn hàng')),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chi tiết đơn hàng',
          style: GoogleFonts.outfit(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Mã đơn hàng', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Text(
                '#' + _order!.id.substring(0, 8).toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                'Đặt lúc ' + dateFormat.format(_order!.createdAt ?? DateTime.now()),
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/support'),
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

              _buildSectionCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusIcon(Icons.check, 'Đã đặt', true),
                        _buildLine(true),
                        _buildStatusIcon(Icons.receipt_long, 'Đã xác nhận', _order!.status != 'PENDING' && _order!.status != 'CANCELLED'),
                        _buildLine(_order!.status == 'SHIPPING' || _order!.status == 'COMPLETED'),
                        _buildStatusIcon(Icons.local_shipping, 'Đang giao', _order!.status == 'SHIPPING' || _order!.status == 'COMPLETED'),
                        _buildLine(_order!.status == 'COMPLETED'),
                        _buildStatusIcon(Icons.check_circle_outline, 'Hoàn thành', _order!.status == 'COMPLETED'),
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
                            child: Text(
                              _getStatusInfo(_order!.status),
                              style: const TextStyle(fontSize: 13, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Sản phẩm đã chọn',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._order!.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildProductItem(
                        item.product.name,
                        '10ml',
                        formatCurrency.format(item.product.price),
                        item.product.imageUrl ?? '',
                        ['Chiết', 'Chính hãng'],
                        item.quantity,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tóm tắt thanh toán',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Tạm tính (' + _order!.items.length.toString() + ' sản phẩm)', formatCurrency.format(_order!.totalAmount)),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Phí vận chuyển', formatCurrency.format(0)),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Voucher giảm giá', '-0đ', valueColor: Colors.green),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng', style: TextStyle(fontSize: 16)),
                        Text(
                          formatCurrency.format(_order!.totalAmount),
                          style: GoogleFonts.outfit(
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
                          Text('Tiền mặt (COD)', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusInfo(String status) {
    switch (status) {
      case 'PENDING': return 'Đơn hàng đang chờ xác nhận từ cửa hàng.';
      case 'SHIPPING': return 'Đơn hàng đang trên đường đến với bạn.';
      case 'COMPLETED': return 'Đơn hàng đã được giao thành công.';
      case 'CANCELLED': return 'Đơn hàng đã bị hủy.';
      default: return 'Cảm ơn bạn đã mua sắm tại Scentie.';
    }
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

  static Widget _buildStatusIcon(IconData icon, String label, bool isActive) {
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

  static Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF7A5E62) : Colors.grey.shade200,
      ),
    );
  }

  Widget _buildProductItem(String name, String capacity, String price, String imgUrl, List<String> tags, int quantity) {
    const Color primaryColor = Color(0xFF7A5E62);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            imgUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.wallpaper),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: primaryColor)),
              Text('Dung tích: ' + capacity, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
            Text(price, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: primaryColor)),
            Text('x' + quantity.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF7A5E62),
          ),
        ),
      ],
    );
  }
}