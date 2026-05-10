import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Product $index'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.productDetail);
            },
          );
        },
      ),
    );
  }
}
