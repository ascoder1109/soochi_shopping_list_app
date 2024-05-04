import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/login_page.dart';
import 'package:shopping_list_app/pages/signup_page.dart';
import 'package:shopping_list_app/provider/card_provider.dart';
import 'package:shopping_list_app/widgets/item_list_card.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemQuantityController = TextEditingController();

    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kAppBackgroundColor,
        title: const Text(
          'Shopping List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (item) => onMenuItemSelected(
                  context, item), // Pass context to handle navigation
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Login'),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text('Settings'),
                    ),
                  ])
        ],
      ),
      body: Consumer<CardProvider>(
        builder: (context, cardProvider, child) {
          return ListView.builder(
            itemCount: cardProvider.items.length,
            itemBuilder: (context, index) {
              final item = cardProvider.items[index];
              return ItemListCard(
                itemName: item.itemName,
                quantity: item.quantity,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(
              context, itemNameController, itemQuantityController);
        },
        shape: const CircleBorder(),
        backgroundColor: kVioletColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    TextEditingController itemNameController,
    TextEditingController itemQuantityController,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)), // Grey border with small radius
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Blue border with larger radius
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter item name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: itemQuantityController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)), // Grey border with small radius
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Blue border with larger radius
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter quantity",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kVioletColor)),
              onPressed: () {
                final itemName = itemNameController.text;
                final itemQuantity = itemQuantityController.text;
                if (itemName.isNotEmpty && itemQuantity.isNotEmpty) {
                  Provider.of<CardProvider>(context, listen: false)
                      .addItem(itemName, itemQuantity);
                }
                itemNameController.clear();
                itemQuantityController.clear();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void onMenuItemSelected(BuildContext context, int item) {
    switch (item) {
      case 1:
        // Navigate to the LoginPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        break;
      case 2:
        // Handle Settings menu item
        break;
      default:
    }
  }
}
