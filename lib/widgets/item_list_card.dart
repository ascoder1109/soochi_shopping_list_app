import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services for accessing system brightness
import 'package:shopping_list_app/colors.dart';
import 'package:provider/provider.dart';
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
  bool _isChecked = false; // Track the state of the checkbox

  @override
  Widget build(BuildContext context) {
    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    Color cardColor = platformBrightness == Brightness.dark
        ? kCardDarkBackgroundColor
        : kCardLightBackgroundColor;
    Color textColor =
        platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isChecked = newValue ?? false;
                    });
                  },
                ),
                SizedBox(width: 16.0), // Add some spacing
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.itemName}",
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                    Text(
                      "Quantity: ${widget.quantity}",
                      style: TextStyle(fontSize: 20, color: textColor),
                    )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    _editItem(context);
                  },
                  icon: Icon(Icons.edit, color: textColor),
                ),
                IconButton(
                  onPressed: () {
                    _deleteItem(context);
                  },
                  icon: Icon(Icons.delete, color: textColor),
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
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
                backgroundColor: MaterialStateProperty.all(kVioletColor),
              ),
              onPressed: () {
                final cardProvider =
                    Provider.of<CardProvider>(context, listen: false);

                int indexToUpdate = cardProvider.items.indexWhere(
                  (item) =>
                      item.itemName == widget.itemName &&
                      item.quantity == widget.quantity,
                );

                if (indexToUpdate != -1) {
                  // Update the item
                  cardProvider.editItem(
                    indexToUpdate,
                    updatedItemName,
                    updatedQuantity,
                  );
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

    int indexToDelete = cardProvider.items.indexWhere(
      (item) =>
          item.itemName == widget.itemName && item.quantity == widget.quantity,
    );

    if (indexToDelete != -1) {
      cardProvider.deleteItem(indexToDelete);
    }
  }
}
