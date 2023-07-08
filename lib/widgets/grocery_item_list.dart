
import 'package:flutter/material.dart';
import 'package:shoping_list/models/grocery_item.dart';

class GroceryItemList extends StatelessWidget {
  final List<GroceryItem> groceryItems;
  final void Function(GroceryItem groceryItem) onRemove;

  const GroceryItemList({super.key, required this.groceryItems, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index) {
        var groceryItem = groceryItems[index];
        return Dismissible(
          key: ValueKey(groceryItem.id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.50),
            margin: const EdgeInsets.symmetric(horizontal: 5),
          ),
          onDismissed: (dismissDirection) => onRemove(groceryItem),
          child: buildListTile(groceryItem, context),
        );
      },
    );
  }

  ListTile buildListTile(GroceryItem groceryItem, BuildContext context) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: groceryItem.category.color,
        ),
      ),
      title: Text(
        groceryItem.name,
        style: Theme.of(context).textTheme.titleSmall!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      trailing: Text(
        '${groceryItem.quantity}',
        style: Theme.of(context).textTheme.titleSmall!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }

}
