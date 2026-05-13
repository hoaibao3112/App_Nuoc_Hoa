import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/product_list/product_list_screen.dart';
import '../screens/product_detail/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/register/register_email_screen.dart';
import '../screens/register/register_otp_screen.dart';
import '../screens/register/register_password_screen.dart';
import '../screens/order_detail/order_detail_screen.dart';
import '../screens/voucher/voucher_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/address_book_screen.dart';
import '../screens/profile/add_address_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/support/support_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String productList = '/product_list';
  static const String productDetail = '/product_detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String registerEmail = '/register_email';
  static const String registerOTP = '/register_otp';
  static const String registerPassword = '/register_password';
  static const String orderDetail = '/order_detail';
  static const String voucher = '/voucher';
  static const String about = '/about';
  static const String editProfile = '/edit_profile';
  static const String addressBook = '/address_book';
  static const String addAddress = '/add_address';
  static const String changePassword = '/change_password';
  static const String support = '/support';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const MainScreen(),
      productList: (context) => const ProductListScreen(),
      productDetail: (context) => const ProductDetailScreen(),
      cart: (context) => const CartScreen(),
      checkout: (context) => const CheckoutScreen(),
      profile: (context) => const ProfileScreen(),
      registerEmail: (context) => const RegisterEmailScreen(),
      registerOTP: (context) => const RegisterOTPScreen(),
      registerPassword: (context) => const RegisterPasswordScreen(),
      orderDetail: (context) => const OrderDetailScreen(),
      voucher: (context) => const VoucherScreen(),
      about: (context) => const AboutScreen(),
      editProfile: (context) => const EditProfileScreen(),
      addressBook: (context) => const AddressBookScreen(),
      addAddress: (context) => const AddAddressScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      support: (context) => const SupportScreen(),
    };
  }
}
