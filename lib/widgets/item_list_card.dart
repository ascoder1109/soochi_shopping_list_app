import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:shopping_list_app/colors.dart';
import 'package:shopping_list_app/provider/card_provider.dart';

class ItemListCard extends StatefulWidget {
  final String itemName;
  final String quantity;

  const ItemListCard({
    Key? key,
    required this.itemName,
    required this.quantity,
  }) : super(key: key);

  @override
  State<ItemListCard> createState() => _ItemListCardState();
}

class _ItemListCardState extends State<ItemListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.itemName}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Quantity: ${widget.quantity}",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    _editItem(context);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _deleteItem(context);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedItemName = widget.itemName;
        String updatedQuantity = widget.quantity;

        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
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
                  hintText: "Edit Name",
                ),
                onChanged: (value) {
                  updatedItemName = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
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
                  hintText: "Edit Quantity",
                ),
                onChanged: (value) {
                  updatedQuantity = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kVioletColor)),
              onPressed: () {
                // Access CardProvider to update the item

                final cardProvider =
                    Provider.of<CardProvider>(context, listen: false);

                int indexToUpdate = cardProvider.items.indexWhere((item) =>
                    item.itemName == widget.itemName &&
                    item.quantity == widget.quantity);

                if (indexToUpdate != -1) {
                  // Update the item
                  cardProvider.editItem(
                      indexToUpdate, updatedItemName, updatedQuantity);
                  Navigator.of(context).pop(); // Close the dialog
                  updatedItemName = ''; // Reset item name
                  updatedQuantity = '';
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context, listen: false);

    int indexToDelete = cardProvider.items.indexWhere((item) =>
        item.itemName == widget.itemName && item.quantity == widget.quantity);

    if (indexToDelete != -1) {
      cardProvider.deleteItem(indexToDelete);
    }
  }
}
