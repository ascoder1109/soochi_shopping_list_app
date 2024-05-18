import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/models/item_model.dart';
import 'package:soochi/provider/item_list_model_provider.dart';
import 'package:soochi/screens/auth/login_page.dart';

import 'package:soochi/screens/shopping_list_page/widget/item_list_card.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DoubleTapToExit(
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // backgroundColor: kAppWhiteColor,
        appBar: AppBar(
          // backgroundColor: kAppWhiteColor,
          // automaticallyImplyLeading: false,
          title: Text(
            "Soochi",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.iconTheme.color),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: theme.iconTheme.color,
                  ),
                  title: Text(
                    "Log-Out",
                    style: TextStyle(color: theme.iconTheme.color),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      barrierDismissible: false,
                    );
                    signOutUser();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have successfully logged out!'),
                        duration:
                            Duration(seconds: 2), // Adjust duration as needed
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddItemDialog(context);
          },
          backgroundColor: kVioletColor,
          foregroundColor: kAppWhiteColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
        body: Consumer<ItemListModel>(
          builder: (context, itemListModel, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: itemListModel.items.map((item) {
                  return ItemListCard(
                    item: item,
                    onCheckboxChanged: (value) {
                      int index = itemListModel.items.indexOf(item);
                      itemListModel.toggleItem(index);
                    },
                    onEdit: () {
                      _showEditItemDialog(context, item);
                    },
                    onDelete: () {
                      Provider.of<ItemListModel>(context, listen: false)
                          .deleteItem(item);
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemQuantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                // style: const TextStyle(color: Colors.black),
                controller: itemNameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter Item Name",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                // style: const TextStyle(color: Colors.black),
                controller: itemQuantityController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter Quantity",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ItemModel newItem = ItemModel(
                  name: itemNameController.text,
                  quantity: itemQuantityController.text,
                );

                Provider.of<ItemListModel>(context, listen: false)
                    .addItem(newItem);

                Navigator.of(context).pop();
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, ItemModel item) {
    TextEditingController itemNameController =
        TextEditingController(text: item.name);
    TextEditingController itemQuantityController =
        TextEditingController(text: item.quantity);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                // style: const TextStyle(color: Colors.black),
                controller: itemNameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter Item Name",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                // style: const TextStyle(color: Colors.black),
                controller: itemQuantityController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: kVioletColor, width: 3),
                  ),
                  hintText: "Enter Quantity",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ItemModel editedItem = ItemModel(
                  name: itemNameController.text,
                  quantity: itemQuantityController.text,
                );

                Provider.of<ItemListModel>(context, listen: false).editItem(
                  Provider.of<ItemListModel>(context, listen: false)
                      .items
                      .indexOf(item),
                  editedItem,
                );

                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signOutUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
    } catch (e) {
      print("Something went wrong");
    }
  }
}
