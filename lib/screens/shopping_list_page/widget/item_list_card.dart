import 'package:flutter/material.dart';
import 'package:soochi/models/item_model.dart';

class ItemListCard extends StatelessWidget {
  final ItemModel item;
  final Function(bool) onCheckboxChanged;
  final Function(bool) onCheckboxStateChanged;
  final VoidCallback onDelete;

  const ItemListCard({
    Key? key,
    required this.item,
    required this.onCheckboxChanged,
    required this.onCheckboxStateChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(24, 0, 0, 0),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        width: double.infinity,
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Checkbox(
                  value: item.isChecked,
                  onChanged: (value) {
                    onCheckboxChanged(value ?? false);
                    // No need to call onCheckboxStateChanged here
                  },
                ),
                SizedBox(width: 16.0), // Add some spacing
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Quantity: ${item.quantity}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete, // Call onDelete when pressed
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red, // Optionally change the color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
