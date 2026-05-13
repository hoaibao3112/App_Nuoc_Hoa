import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'order_history/order_history_screen.dart';
import 'profile/profile_screen.dart';
import 'cart/cart_screen.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color activeBgColor = const Color(0xFFFFD1D1);

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await ApiClient.secureStorage.read(key: 'accessToken');
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép body tràn xuống dưới thanh điều hướng nếu cần
      resizeToAvoidBottomInset: false, // Ngăn bàn phím đẩy thanh điều hướng lên (nếu muốn)
      body: Stack(
        children: [
          // Nội dung màn hình hiện tại
          Positioned.fill(
            child: _screens[_selectedIndex],
          ),
          // Thanh điều hướng nổi (Bottom Nav)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: _buildBottomNavStack(),
            ),
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
                _buildNavItem(1, Icons.shopping_cart_outlined, 'Giỏ hàng'),
                _buildNavItem(2, Icons.shopping_bag_outlined, 'Đơn hàng'),
                _buildNavItem(3, _isLoggedIn ? Icons.person_outline : Icons.login_outlined, _isLoggedIn ? 'Cá nhân' : 'Đăng nhập'),
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
        if (index == 3 && !_isLoggedIn) {
          Navigator.pushNamed(context, '/login');
          return;
        }
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
            index == 1 
              ? Consumer<CartProvider>(
                  builder: (context, cart, child) => Badge(
                    label: Text(cart.itemCount.toString()),
                    isLabelVisible: cart.itemCount > 0,
                    backgroundColor: const Color(0xFFD32F2F),
                    child: Icon(
                      icon,
                      color: primaryTextColor,
                      size: 22,
                    ),
                  ),
                )
              : Icon(
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
