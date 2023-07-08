import 'package:shoping_list/models/category.dart';

class GroceryItem {
  String? id;
  final String name;
  final int quantity;
  final Category category;

  GroceryItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  void setId(String id) {
    this.id = id;
  }
}
