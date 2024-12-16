import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/core/dtos/item_dto.dart';
import 'package:soochi/core/services/item_service.dart';

import '../viewmodels/item_card_view_model.dart';
import '../viewmodels/selected_shopping_list_view_model.dart';

class ItemCardWidget extends StatefulWidget {
  final ItemDTO item;
  final int shoppingListId;

  ItemCardWidget({
    required this.item,
    required this.shoppingListId,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemCardViewModel(widget.item, ItemService()),
      child: Consumer<ItemCardViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 0,
              child: Row(
                children: [
                  // Checkbox at the extreme left
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Checkbox(
                      value: viewModel.item.isChecked,
                      onChanged: (bool? value) async {
                        if (value != null) {
                          await viewModel.toggleCheck(widget.shoppingListId);
                        }
                      },
                    ),
                  ),
                  // Item name and quantity
                  Expanded(
                    child: ListTile(
                      title: Text(viewModel.item.name),
                      subtitle: Text(viewModel.item.quantity),
                    ),
                  ),
                  // Edit and Delete buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Handle edit logic here
                          _showEditDialog(context, viewModel);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final selectedShoppingListViewModel =
                          Provider.of<SelectedShoppingListViewModel>(context, listen: false);
                          await selectedShoppingListViewModel.deleteItem(viewModel.item.id);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, ItemCardViewModel viewModel) async {
    final nameController = TextEditingController(text: viewModel.item.name);
    final quantityController = TextEditingController(text: viewModel.item.quantity);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await viewModel.updateItem(
                  widget.shoppingListId,
                  nameController.text,
                  quantityController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
