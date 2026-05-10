import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'product_list/product_list_screen.dart';
import 'order_history/order_history_screen.dart';
import 'profile/profile_screen.dart';
import 'cart/cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductListScreen(),
    const CartScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color activeBgColor = const Color(0xFFFFD1D1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavStack(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavStack() {
    return Container(
      height: 120, // Increased height to accommodate the overlapping button
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The Navigation Bar
          Container(
            height: 85,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, 'Trang chủ'),
                _buildNavItem(1, Icons.grid_view_outlined, 'B.Sưu tập'),
                _buildNavItem(2, Icons.shopping_cart_outlined, 'Giỏ hàng'),
                _buildNavItem(3, Icons.shopping_bag_outlined, 'Đơn hàng'),
                _buildNavItem(4, Icons.person_outline, 'Cá nhân'),
                const SizedBox(width: 50), // Space for FAB
              ],
            ),
          ),
          // The AI Button (Higher position)
          Positioned(
            right: 25,
            top: 5, // Moves it higher up
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(35),
                  child: Center(
                    child: Icon(Icons.auto_awesome, color: primaryTextColor, size: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryTextColor,
              size: 22,
            ),
            if (isActive)
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
