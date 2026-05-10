import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';
import '../../services/product_service.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();
  
  List<Product> relatedProducts = [];
  bool isLoadingRelated = true;
  String selectedVolume = '10ml';
  
  final Color primaryTextColor = const Color(0xFF5D4037);

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }

  Future<void> _fetchRelatedProducts() async {
    final fetched = await _productService.getProducts(limit: 4);
    if (mounted) {
      setState(() {
        relatedProducts = fetched;
        isLoadingRelated = false;
      });
    }
  }

  void _addToCart(Product product) async {
    final success = await _cartService.addToCart(product.id, 1);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào giỏ hàng!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi khi thêm vào giỏ hàng.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nhận dữ liệu product được truyền sang từ HomeScreen
    final Product? product = ModalRoute.of(context)?.settings.arguments as Product?;
    if (product == null) return const Scaffold(body: Center(child: Text('Không tìm thấy sản phẩm')));

    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh chính
            Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFDEAEB),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: SafeArea(
                child: Center(
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: Image.network(
                      product.imageUrl ?? 'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=400&q=80',
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Ảnh thumbnail (demo cứng)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThumbnail('https://images.unsplash.com/photo-1594035910387-fea47794261f?w=100&q=80', true),
                const SizedBox(width: 15),
                _buildThumbnail('https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?w=100&q=80', false),
                const SizedBox(width: 15),
                _buildThumbnail('https://images.unsplash.com/photo-1587442157077-43c7b2cc8939?w=100&q=80', false),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LE LABO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.5)),
                      Row(children: List.generate(3, (index) => Icon(Icons.star, size: 14, color: primaryTextColor))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: formatCurrency.format(product.price),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
                        ),
                        TextSpan(
                          text: ' / 10ml',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mô tả sản phẩm
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.description ?? 'Một mùi hương trong veo, sạch sẽ nhưng lại mang đến cảm giác da thịt. Một người có phong cách tinh tế, nhẹ nhàng.',
                          style: TextStyle(fontSize: 12, height: 1.5, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 16),
                        _buildScentTagRow('Hương Đầu', ['Quả Lê', 'Cam Chanh'], const Color(0xFFFFE5E5)),
                        const SizedBox(height: 8),
                        _buildScentTagRow('Hương Giữa', ['Ambrette', 'Salicylate'], const Color(0xFFE5E8FF)),
                        const SizedBox(height: 8),
                        _buildScentTagRow('Hương Cuối', ['Hạt Vông Vang'], const Color(0xFFE5FFE8)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Chọn dung tích
                  Text('Chọn Dung Tích', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildVolumeOption('5ml', selectedVolume == '5ml'),
                      const SizedBox(width: 16),
                      _buildVolumeOption('10ml', selectedVolume == '10ml'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Nút Thêm giỏ hàng
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.favorite_border, color: primaryTextColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8C3C8), // Màu hồng nhạt nút Thêm vào giỏ
                            foregroundColor: primaryTextColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Có thể bạn sẽ thích
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Có thể bạn sẽ thích', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor)),
                      Text('Xem tất cả →', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isLoadingRelated) 
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final p = relatedProducts[index];
                          return _buildMiniProductCard(p, formatCurrency);
                        },
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String url, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? primaryTextColor : Colors.transparent, width: 2),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildScentTagRow(String title, List<String> tags, Color tagBgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 6),
        Row(
          children: tags.map((t) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: tagBgColor, borderRadius: BorderRadius.circular(12)),
              child: Text(t, style: TextStyle(fontSize: 10, color: Colors.grey[800])),
            ),
          )).toList(),
        )
      ],
    );
  }

  Widget _buildVolumeOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedVolume = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDEAEB) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF5D4037) : Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryTextColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniProductCard(Product p, NumberFormat formatCurrency) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                p.imageUrl ?? 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=200&q=80',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('BRAND', style: TextStyle(fontSize: 8, color: Colors.grey[600])),
          Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
          const Spacer(),
          Text(formatCurrency.format(p.price), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
        ],
      ),
    );
  }
}
