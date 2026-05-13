import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../models/cart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = false;
  String _selectedPaymentMethod = 'momo'; // momo, bank, cod

  // Delivery Info State
  String _receiverName = 'Nguyễn Văn A';
  String _receiverPhone = '090 1234 567';
  String _shippingAddress = 'Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCart();
    });
  }

  Future<void> _loadCart() async {
    context.read<CartProvider>().fetchCart();
  }

  Future<void> _handleCheckout() async {
    final cartProvider = context.read<CartProvider>();
    if (cartProvider.items.isEmpty) return;

    setState(() => _isLoading = true);

    final order = await _orderService.createOrder();

    if (mounted) {
      setState(() => _isLoading = false);

      if (order != null) {
        // Clear cart in provider
        await cartProvider.clearCart();

        // Show Success Dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text('Đặt hàng thành công!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Mã đơn hàng: ${order.id.split("-")[0].toUpperCase()}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4C52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Tiếp tục mua sắm', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6B4C52); // Dark brownish red
    const Color bgColor = Color(0xFFF9F7F7);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.items;
        final isLoading = cartProvider.isLoading || _isLoading;
        final totalPrice = cartProvider.totalAmount;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Thanh toán', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
            centerTitle: true,
            backgroundColor: bgColor,
            elevation: 0,
            automaticallyImplyLeading: false, // Hide back button for bottom nav
          ),
          body: isLoading && cartItems.isEmpty
              ? const Center(child: CircularProgressIndicator(color: primaryColor))
              : cartItems.isEmpty
                  ? _buildEmptyCart()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sản phẩm của bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                              Text('${cartItems.length} sản phẩm', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Product List
                          ...cartItems.map((item) => _buildProductItem(item, formatCurrency, primaryColor)),
                          
                          const SizedBox(height: 8),

                          // Promo Code
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_activity_outlined, color: primaryColor, size: 20),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Nhập mã giảm giá...',
                                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Áp dụng', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Delivery Info
                          const Text('Thông tin giao hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _showAddressForm(context, primaryColor),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined, color: primaryColor, size: 24),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(_receiverName.isNotEmpty ? _receiverName : 'Chưa có tên', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(width: 8),
                                            Container(width: 1, height: 14, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text(_receiverPhone.isNotEmpty ? _receiverPhone : 'Chưa có SĐT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _shippingAddress.isNotEmpty ? _shippingAddress : 'Vui lòng cập nhật địa chỉ giao hàng...',
                                          style: TextStyle(fontSize: 13, color: _shippingAddress.isNotEmpty ? Colors.grey : Colors.red, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Payment Method
                          const Text('Phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                          const SizedBox(height: 16),
                          _buildPaymentOption('momo', 'Ví MoMo', Icons.account_balance_wallet),
                          const SizedBox(height: 12),
                          _buildPaymentOption('bank', 'Chuyển khoản ngân hàng', Icons.account_balance),
                          const SizedBox(height: 12),
                          _buildPaymentOption('cod', 'Thanh toán khi nhận hàng\n(COD)', Icons.money),
                          const SizedBox(height: 24),

                          // Summary
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(height: 20),
                                _buildSummaryRow('Tạm tính (${cartItems.length} sản phẩm)', formatCurrency.format(totalPrice)),
                                const SizedBox(height: 12),
                                _buildSummaryRow('Phí vận chuyển', 'Miễn phí', valueColor: Colors.green),
                                const SizedBox(height: 12),
                                _buildSummaryRow('Giảm giá', '-0đ', valueColor: Colors.green),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Divider(color: Color(0xFFF0F0F0)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Tổng tiền', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(formatCurrency.format(totalPrice), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                                        const Text('(Đã bao gồm VAT)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Order Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: isLoading ? null : _handleCheckout,
                              icon: const Text(''), // Spacer
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(isLoading ? 'Đang xử lý...' : 'Đặt hàng ngay', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  if (!isLoading) const Icon(Icons.check_circle_outline, size: 20),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'Bằng cách nhấn Đặt hàng, bạn đồng ý với các Điều khoản\n& Chính sách của Scentie.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('Giỏ hàng của bạn đang trống', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductItem(CartItem item, NumberFormat formatCurrency, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty
                  ? Image.network(item.product.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.water_drop, color: Colors.grey))
                  : const Icon(Icons.water_drop, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '10ml • Số lượng: ${item.quantity}', // Hardcoded 10ml for now as per design
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency.format(item.product.price),
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    final bool isSelected = _selectedPaymentMethod == value;
    final Color primaryColor = const Color(0xFF6B4C52);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAF2F3) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryColor : Colors.white),
          boxShadow: [
            if (!isSelected)
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showAddressForm(BuildContext context, Color primaryColor) {
    final nameController = TextEditingController(text: _receiverName);
    final phoneController = TextEditingController(text: _receiverPhone);
    final emailController = TextEditingController();
    final addressController = TextEditingController(text: _shippingAddress == 'Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố...' ? '' : _shippingAddress);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thông tin giao hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Họ và tên'),
              _buildTextField(nameController, 'Nhập họ tên của bạn'),
              const SizedBox(height: 16),
              _buildInputLabel('Số điện thoại'),
              _buildTextField(phoneController, 'Nhập số điện thoại', isPhone: true),
              const SizedBox(height: 16),
              _buildInputLabel('Email (Không bắt buộc)'),
              _buildTextField(emailController, 'Nhập địa chỉ email'),
              const SizedBox(height: 16),
              _buildInputLabel('Địa chỉ nhận hàng'),
              _buildTextField(addressController, 'Số nhà, tên đường, phường/xã, quận/huyện...', maxLines: 2),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _receiverName = nameController.text.trim();
                      _receiverPhone = phoneController.text.trim();
                      _shippingAddress = addressController.text.trim();
                    });
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Lưu thông tin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPhone = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
