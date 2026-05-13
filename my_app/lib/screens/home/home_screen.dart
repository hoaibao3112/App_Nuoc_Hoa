import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';
import '../../services/auth_service.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../../widgets/custom_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final AuthService _authService = AuthService();
  
  List<Product> products = [];
  List<Category> categories = [];
  User? currentUser;
  bool isLoading = true;
  bool isCategoriesLoading = true;

  final Color primaryTextColor = const Color(0xFF5D4037);
  final Color accentColor = const Color(0xFFFDEAEB);

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await _productService.getProducts(limit: 5);
      final fetchedCategories = await _categoryService.getCategories();
      final profile = await _authService.getProfile();
      
      if (mounted) {
        setState(() {
          products = fetchedProducts;
          categories = fetchedCategories;
          currentUser = profile;
          isLoading = false;
          isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isCategoriesLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải dữ kết nối server: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title: currentUser?.name ?? 'Scentie User',
          onNotificationPressed: () {
            // Navigator.pushNamed(context, '/notifications');
          },
          onSearchPressed: () {
            // Navigator.pushNamed(context, '/search');
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBanner(),
                const SizedBox(height: 30),
                _buildFavoriteScents(),
                const SizedBox(height: 30),
                _buildFeaturedProducts(context),
                const SizedBox(height: 30),
                _buildStudentBanner(),
                const SizedBox(height: 30),
                _buildReviews(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Image.network(
                'https://img.freepik.com/free-photo/elegant-perfume-bottle-with-flowers_23-2148894178.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.pink[100],
                  child: const Center(child: Icon(Icons.image_not_supported, color: Colors.pink)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'New Arrival',
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'BST Scentie\nMùa Hạ 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteScents() {
    return Column(
      children: [
        Center(
          child: Text(
            'Mùi Hương Yêu Thích',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isCategoriesLoading)
          const Center(child: CircularProgressIndicator())
        else if (categories.isEmpty)
          const Center(child: Text('Chưa có danh mục nào'))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildScentItem(cat.name, cat.imageUrl ?? 'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=200&q=80'),
              )).toList(),
            ),
          )
      ],
    );
  }

  Widget _buildScentItem(String title, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        )
      ],
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản Phẩm Nổi Bật',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product_list');
                },
                child: Text(
                  'Xem tất cả →',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (products.isEmpty)
          const Center(child: Text('Chưa có sản phẩm nào'))
        else
          SizedBox(
            height: 330,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product, index);
              },
            ),
          )
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, int index) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final tags = index % 2 == 0 ? ['Bestseller'] : ['New'];
    final tagBg = index % 2 == 0 ? const Color(0xFFFFD1D1) : const Color(0xFFC8E6C9);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product_detail', arguments: product);
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tags[0],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl ?? 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=300&q=80',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMiniTag('Hương Hoa'),
                const SizedBox(width: 4),
                _buildMiniTag('Ngọt Ngào'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.description ?? '10ml',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatCurrency.format(product.price),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryTextColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                    ],
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStudentBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFD3EADD),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Back to School', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ưu đãi cho sinh viên',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Giảm ngay 10% khi xác thực thẻ sinh viên hợp lệ.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF072A20),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Nhận mã ngay', style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      children: [
        Center(
          child: Text(
            'Góc chia sẻ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _buildReviewCard('Minh Anh', 'Sinh viên ĐH Kinh Tế', 'Shop đóng gói cực kỳ xinh xắn, mùi Replica lưu hương khá lâu trên da mình. Sẽ ủng hộ dài dài nha!', 'M'),
              const SizedBox(width: 16),
              _buildReviewCard('Thảo Vy', 'Sinh viên RMIT', 'Mua chai chiết dùng thử ưng quá phải mua thêm. Giá hợp lý cho sinh viên tụi mình.', 'T', avatarColor: Colors.pink[100]),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildReviewCard(String name, String subName, String content, String initial, {Color? avatarColor}) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) => const Icon(Icons.star, size: 14, color: Color(0xFF5D4037))),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              '"$content"',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
          ),
          const Divider(),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: avatarColor ?? Colors.indigo[100],
                child: Text(initial, style: TextStyle(color: primaryTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
                  Text(subName, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}