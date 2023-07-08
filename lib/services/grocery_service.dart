import 'dart:convert';

import 'package:shoping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_list/constants/constant.dart' as constant;

final uri = Uri.https(constant.FIREBASE_DATABASE_URL, "${constant.SHOPPING_LIST_COLLECTION}.json");

Future<http.Response> insertGroceryItem(GroceryItem groceryItem) {
  return http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "name": groceryItem.name,
      "quantity": groceryItem.quantity,
      "category": groceryItem.category.name
    }),
  );
}

Future<http.Response> findAllGroceries() {
  return http.get(uri, headers: {"Content-Type": "application/json"});
}

Future<http.Response> deleteGrocery(String id) {
  var deleteUri = Uri.https(constant.FIREBASE_DATABASE_URL, "${constant.SHOPPING_LIST_COLLECTION}/$id.json");
  return http.delete(deleteUri, headers: {"Content-Type": "application/json"});
}
