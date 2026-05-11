import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/order_service.dart';
import '../../models/order.dart' as model;
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderService _orderService = OrderService();
  List<model.Order> allOrders = [];
  bool isLoading = true;
  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFFDEAEB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final fetched = await _orderService.getOrders();
    if (mounted) {
      setState(() {
        allOrders = fetched;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50), // Header space
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scentie',
                style: GoogleFonts.outfit(color: primaryTextColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Icon(Icons.shopping_bag_outlined, color: primaryTextColor),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lịch sử đơn hàng',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                'Theo dõi các mùi hương thanh xuân bạn đã chọn',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: primaryTextColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          tabs: [
            _buildTab('Tất cả', true),
            _buildTab('Chờ xác nhận', false),
            _buildTab('Đang giao', false),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isLoading 
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(allOrders),
                  _buildOrderList(allOrders.where((o) => o.status == 'PENDING').toList()),
                  _buildOrderList(allOrders.where((o) => o.status == 'SHIPPING').toList()),
                ],
              ),
        ),
      ],
    );
  }


  Widget _buildTab(String label, bool isActive) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFD1D1).withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.transparent : Colors.grey[200]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<model.Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'Chưa có đơn hàng nào',
          style: GoogleFonts.outfit(color: Colors.grey),
        ),
      );
    }
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ListView.separated(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),

      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final order = orders[index];
        final firstProduct = order.items.isNotEmpty ? order.items[0].product : null;
        
        return _buildOrderCard(
          id: '#${order.id.substring(0, 8).toUpperCase()}',
          date: order.createdAt != null ? dateFormat.format(order.createdAt!) : 'N/A',
          status: _getStatusText(order.status),
          statusColor: _getStatusColor(order.status),
          productName: firstProduct?.name ?? 'Sản phẩm',
          productTags: ['Chiết', 'Chính hãng'],
          price: formatCurrency.format(order.totalAmount),
          imageUrl: firstProduct?.imageUrl ?? 'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=200&q=80',
          action1: 'Chi tiết',
          action2: order.status == 'COMPLETED' ? 'Mua lại' : 'Liên hệ hỗ trợ',
          isCanceled: order.status == 'CANCELLED',
        );
      },
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING': return 'Chờ xác nhận';
      case 'SHIPPING': return 'Đang giao';
      case 'COMPLETED': return 'Hoàn thành';
      case 'CANCELLED': return 'Đã hủy';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CANCELLED': return const Color(0xFFFFCDD2);
      default: return const Color(0xFFC8E6C9);
    }
  }

  Widget _buildOrderCard({
    required String id,
    required String date,
    required String status,
    required Color statusColor,
    required String productName,
    required List<String> productTags,
    required String price,
    required String imageUrl,
    required String action1,
    String? action2,
    bool isCanceled = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD1D1).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  id,
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    if (isCanceled) const Icon(Icons.cancel_outlined, size: 12, color: Colors.red),
                    if (!isCanceled) const Icon(Icons.local_shipping_outlined, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: isCanceled ? Colors.red : Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ngày đặt: $date',
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(imageUrl, height: 80, width: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: productTags.map((t) => Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(t, style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[600])),
                      )).toList(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      price,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Text(action1, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
                ),
              ),
              if (action2 != null) ...[
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(action2, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
