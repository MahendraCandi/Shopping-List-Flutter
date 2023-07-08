import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_list/data/categories_data.dart';
import 'package:shoping_list/models/category.dart';
import 'package:shoping_list/models/grocery_item.dart';
import 'package:shoping_list/services/grocery_service.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddItemState();
  }
}

class _AddItemState extends State<AddItem> {

  final _formKey = GlobalKey<FormState>();
  var _name = "";
  var _qty = 0;
  Category? _category;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      var groceryItem = GroceryItem(name: _name, quantity: _qty, category: _category!);
      final response = await insertGroceryItem(groceryItem);

      // the response body is {"name":"-NZGNpmdOmBdckWN5uwd"}
      Map<String, dynamic> body = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      groceryItem.setId(body["name"]);
      Navigator.of(context).pop(groceryItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length > 50) {
                    return "Invalid value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
                style: Theme.of(context).textTheme.titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number,
                      initialValue: "1",
                      validator: (value) {
                        // tryParse would return null if error occurred when parsing value
                        if (value == null || value.isEmpty || int.tryParse(value) == null ||
                            int.tryParse(value)! > 9999 || int.tryParse(value)! < 0) {
                          return "Invalid value";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _qty = int.parse(value!);
                      },
                      style: Theme.of(context).textTheme.titleSmall!
                          .copyWith(color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(label: Text("Category")),
                      validator: (value) {
                        if (value == null) {
                          return "Invalid value";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _category = value!;
                      },
                      items: categoriesData.entries
                          .map((category) => DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category.value.name,
                                        style: Theme.of(context).textTheme.titleSmall!
                                            .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    // onPressed: null => will disabled the button
                    onPressed: _isSending ? null : () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    // onPressed: null => will disabled the button
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Submit"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
