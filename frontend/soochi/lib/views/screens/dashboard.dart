import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/dtos/item_dto.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/item_card_widget.dart';
import '../viewmodels/selected_shopping_list_view_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _showAddItemDialog(int shoppingListId) async {
    final selectedShoppingListViewModel =
    Provider.of<SelectedShoppingListViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final quantity = _quantityController.text.trim();

                if (name.isNotEmpty && quantity.isNotEmpty) {
                  try {

                    final newItem = ItemDTO(
                      id: 0,
                      name: name,
                      quantity: quantity,
                      isChecked: false,
                    );

                    await selectedShoppingListViewModel.addItem(newItem);


                    Navigator.of(context).pop();
                    _nameController.clear();
                    _quantityController.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add item: $e')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SelectedShoppingListViewModel>(
          builder: (context, selectedShoppingListViewModel, child) {
            final selectedListName =
                selectedShoppingListViewModel.selectedListName;
            return Text(
              selectedListName ?? "Welcome",
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      drawer: const DrawerWidget(),
      body: Consumer<SelectedShoppingListViewModel>(
        builder: (context, selectedShoppingListViewModel, child) {
          if (selectedShoppingListViewModel.isLoadingItems) {
            return const Center(child: CircularProgressIndicator());
          }

          if (selectedShoppingListViewModel.items.isEmpty) {
            return const Center(
                child: Text("No items found for this shopping list"));
          }

          final shoppingListId =
              selectedShoppingListViewModel.selectedListId ?? 0;

          return ListView.builder(
            itemCount: selectedShoppingListViewModel.items.length,
            itemBuilder: (context, index) {
              final item = selectedShoppingListViewModel.items[index];
              return ItemCardWidget(
                item: item,
                shoppingListId: shoppingListId,
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<SelectedShoppingListViewModel>(
        builder: (context, selectedShoppingListViewModel, child) {
          final shoppingListId =
              selectedShoppingListViewModel.selectedListId ?? 0;

          return FloatingActionButton(
            onPressed: () {
              _showAddItemDialog(shoppingListId);
            },
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
