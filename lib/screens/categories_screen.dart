import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_list/data/categories_data.dart';
import 'package:shoping_list/models/category.dart';
import 'package:shoping_list/models/grocery_item.dart';
import 'package:shoping_list/screens/add_item.dart';
import 'package:shoping_list/services/grocery_service.dart';
import 'package:shoping_list/widgets/grocery_item_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<GroceryItem> _groceryItems = [];
  var _isLoadingItems = true;
  String? _requestError;

  @override
  void initState() {
    super.initState();

    _loadItem();
  }

  void _loadItem() async {
    var response = await findAllGroceries();

    if (response.statusCode > 400) {
      setState(() {
        _requestError = "Failed load items. An error occurred when fetching the data.";
      });
    }

    // the Firebase would return string of "null" whenever data is empty
    if (response.body == "null") {
      setState(() {
        _isLoadingItems = false;
      });

      return;
    }

    // json.decode return dynamic type which we can explicit initiate with structure of json body
    // since the body from Firebase realtime database would look like this:
    // {
    // 	"-NZG1-vPI6XFEKBrIUCD": {
    // 		"category": "Fruit",
    // 		"name": "semangka",
    // 		"quantity": 15
    // 	},
    // 	"-NZG17PjjXQGM7cLZgRh": {
    // 		"category": "Meat",
    // 		"name": "Kambing Ketawa",
    // 		"quantity": 5
    // 	}
    // }
    // then let's explicitly initiate the dynamic type into Map<String, dynamic>
    Map<String, dynamic> groceriesData = json.decode(response.body);

    List<GroceryItem> loadedItems = [];
    for (MapEntry<String, dynamic> data in groceriesData.entries) {
      Category category = categoriesData.entries
          .firstWhere((element) => element.value.name == data.value["category"])
          .value;

      loadedItems.add(GroceryItem(
          id: data.key,
          name: data.value["name"],
          quantity: data.value["quantity"],
          category: category));
    }

    setState(() {
      _groceryItems = loadedItems;
      _isLoadingItems = false;
    });
  }

  void _addItem(BuildContext context) async {
    var groceryItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const AddItem()));

    if (groceryItem == null) return;

    setState(() {
      _groceryItems.add(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainBody;
    if (_isLoadingItems) {
      mainBody = const Center(child: CircularProgressIndicator(),);
    } else {
      mainBody = _groceryItems.isEmpty ? showNoItem(context) :
      GroceryItemList(groceryItems: _groceryItems, onRemove: _removeItem);
    }

    if (_requestError != null) {
      mainBody = Center(
        child: Text(
          _requestError!,
          style: Theme.of(context).textTheme.titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Categories")),
      body: mainBody,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _addItem(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _removeItem(GroceryItem groceryItem) async {
    var indexOf = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.removeAt(indexOf);
    });

    var response = await deleteGrocery(groceryItem.id!);

    if (!context.mounted) {
      return;
    }

    if (response.statusCode > 400) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "Failed delete items",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      setState(() {
        _groceryItems.insert(indexOf, groceryItem);
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Item deleted!"),
        ),
      );
    }
  }

  Center showNoItem(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "No item present!",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          Text(
            "You could start adding items by tap plus button in the bottom",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          )
        ],
      ),
    );
  }
}
