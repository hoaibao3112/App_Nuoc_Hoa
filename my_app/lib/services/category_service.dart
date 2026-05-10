import '../models/category.dart';
import '../utils/constants.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    try {
      final response = await ApiClient.dio.get('/categories');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data;
        return items.map((json) => Category.fromJson(json)).toList();
      }
    } catch (e) {
      print('Get categories error: $e');
    }
    return [];
  }
}
