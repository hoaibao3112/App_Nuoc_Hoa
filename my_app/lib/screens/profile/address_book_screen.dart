import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/address_service.dart';
import '../../models/address.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final Color primaryTextColor = const Color(0xFF6B4C52); // Dark brownish red
  final Color bgColor = const Color(0xFFF9F7F7);
  final AddressService _addressService = AddressService();
  List<Address> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final addresses = await _addressService.getAddresses();
    if (mounted) {
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    }
  }

  IconData _getIconForTitle(String title) {
    if (title.toLowerCase().contains('nhà')) return Icons.home_outlined;
    if (title.toLowerCase().contains('văn phòng') || title.toLowerCase().contains('công ty')) return Icons.work_outline;
    return Icons.location_on_outlined;
  }

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
          'Sổ địa chỉ',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: primaryTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lưu giữ các địa chỉ nhận hàng để trải nghiệm mua sắm mượt mà hơn cùng Scentie.',
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 24),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_addresses.isEmpty)
              const Center(child: Text('Chưa có địa chỉ nào được lưu.'))
            else
              ..._addresses.map((addr) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildAddressCard(
                  icon: _getIconForTitle(addr.title),
                  title: addr.title,
                  name: addr.receiverName,
                  phone: addr.phone,
                  address: addr.address,
                  isDefault: addr.isDefault,
                ),
              )),
            
            const SizedBox(height: 16),

            // Delivery info banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFCF3F4), Color(0xFFF1F6F4)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_shipping_outlined, color: primaryTextColor, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Giao hàng hương sắc',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF98555E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scentie cam kết các đơn hàng decant luôn được đóng gói kỹ lưỡng và giao đến địa chỉ của bạn nhanh nhất để giữ trọn vẹn mùi hương thanh xuân.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Footer text
            Center(
              child: Column(
                children: [
                  Text('Scentie', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor)),
                  const SizedBox(height: 4),
                  Text('© 2024 Scentie - Mùi Hương\nThanh Xuân', textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 16),
                  Text('Về chúng tôi', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text('Chính sách bảo mật và điều khoản', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating button can be added if needed, but not in screenshot. We could add a button to add new address.
    );
  }

  Widget _buildAddressCard({
    required IconData icon,
    required String title,
    required String name,
    required String phone,
    required String address,
    bool isDefault = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(icon, color: primaryTextColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD1D1).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'MẶC ĐỊNH',
                    style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.edit, size: 14, color: primaryTextColor),
                  const SizedBox(width: 4),
                  Text('Chỉnh sửa', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(name, style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87)),
              const SizedBox(width: 8),
              Container(width: 1, height: 12, color: Colors.grey.shade300),
              const SizedBox(width: 8),
              Text(phone, style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}
