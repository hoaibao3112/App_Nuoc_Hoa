import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Giỏ hàng của bạn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.checkout);
            },
            child: const Text('Tiến hành thanh toán'),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

}
