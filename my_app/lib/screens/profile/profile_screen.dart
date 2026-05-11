import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? currentUser;
  bool isLoading = true;

  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFFDEAEB);

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final profile = await _authService.getProfile();
    if (mounted) {
      setState(() {
        currentUser = profile;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: currentUser?.avatarUrl != null 
                          ? NetworkImage(currentUser!.avatarUrl!) 
                          : const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80'),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Color(0xFF5D4037), shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.name ?? 'Khách hàng',
                        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currentUser?.email ?? '',
                        style: GoogleFonts.outfit(fontSize: 12, color: primaryTextColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5D4037).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Hạng Bạc', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: primaryTextColor)),
                          ),
                          const SizedBox(width: 10),
                          Text('• 1,250 điểm', style: GoogleFonts.outfit(fontSize: 12, color: primaryTextColor.withOpacity(0.7))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Order Summary
            _buildActionCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Đơn hàng của tôi',
              subtitle: '1 đơn hàng đang giao',
              onTap: () {},
              iconBgColor: const Color(0xFFFFD1D1).withOpacity(0.3),
            ),
            const SizedBox(height: 25),
            // Main Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.person_outlined, 'Thông tin tài khoản', onTap: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  }),
                  _buildDivider(),
                  _buildListTile(Icons.location_on_outlined, 'Sổ địa chỉ', onTap: () {
                    Navigator.pushNamed(context, '/address_book');
                  }),
                  _buildDivider(),
                  _buildListTile(Icons.confirmation_num_outlined, 'Voucher của tôi', badge: '2 MỚI'),
                  _buildDivider(),
                  _buildListTile(Icons.favorite_border, 'Sản phẩm đã thích'),
                  _buildDivider(),
                  _buildListTile(Icons.star_outlined, 'Đánh giá của tôi'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Help & Settings
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.headset_mic_outlined, 'Hỗ trợ & Liên hệ'),
                  _buildDivider(),
                  _buildListTile(Icons.settings_outlined, 'Cài đặt'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Logout
            TextButton.icon(
              onPressed: () async {
                final success = await _authService.logout();
                if (success && mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                'Đăng xuất',
                style: GoogleFonts.outfit(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }


  Widget _buildActionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap, required Color iconBgColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: primaryTextColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor)),
                  Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {String? badge, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryTextColor, size: 22),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFD1D1), borderRadius: BorderRadius.circular(10)),
              child: Text(badge, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: primaryTextColor)),
            ),
          const SizedBox(width: 5),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[100], indent: 60);
  }
}
