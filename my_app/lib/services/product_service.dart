import '../models/product.dart';
import '../utils/constants.dart';

class ProductService {
  Future<List<Product>> getProducts({int page = 1, int limit = 10, String? search}) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      final response = await ApiClient.dio.get('/products', queryParameters: queryParams);
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        return items.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      print('Get products error: $e');
    }
    return [];
  }

  Future<Product?> getProductDetail(String id) async {
    try {
      final response = await ApiClient.dio.get('/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
    } catch (e) {
      print('Get product detail error: $e');
    }
    return null;
  }
}
