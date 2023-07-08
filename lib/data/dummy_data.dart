import 'package:shoping_list/data/categories_data.dart';
import 'package:shoping_list/enums/categories.dart';
import 'package:shoping_list/models/grocery_item.dart';

var groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categoriesData[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categoriesData[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categoriesData[Categories.meat]!),
];
