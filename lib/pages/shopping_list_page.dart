import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/pages/login_page.dart';
import 'package:shopping_list_app/provider/card_provider.dart';
import 'package:shopping_list_app/services/auth_service.dart';
import 'package:shopping_list_app/widgets/item_list_card.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemQuantityController = TextEditingController();

    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    Color scaffoldBackgroundColor = platformBrightness == Brightness.dark
        ? kAppDarkBackgroundColor
        : kAppLightBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Soochi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert), // Three-dot icon
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'sign_out',
                  child: Text('Sign Out'),
                ),

                // Add more PopupMenuItems as needed
              ];
            },

            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'sign_out':
                  signOutUser();
                  Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Logged-Out Successfully'),
                      duration:
                          Duration(seconds: 2), // Adjust the duration as needed
                    ),
                  );
                  break;
              }
            },
          )
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
}

Future<void> signOutUser() async {
  final _auth = AuthService();
  try {
    await _auth.signOut();
  } catch (e) {
    print("Something went wrong");
  }
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
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
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
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
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
