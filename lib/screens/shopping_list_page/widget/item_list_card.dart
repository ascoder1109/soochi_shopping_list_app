import 'package:flutter/material.dart';
import 'package:soochi/colors.dart';
import 'package:soochi/models/item_model.dart';

class ItemListCard extends StatelessWidget {
  final ItemModel item;
  final Function(bool) onCheckboxChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ItemListCard({
    Key? key,
    required this.item,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        width: double.infinity,
        child: Card(
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CheckboxTheme(
                  data: CheckboxThemeData(
                    fillColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return kVioletColor;
                      }
                      if (theme.brightness == Brightness.light) {
                        return kAppBlackColor;
                      } else {
                        return Colors.white;
                      }
                    }),
                  ),
                  child: Checkbox(
                    value: item.isChecked,
                    onChanged: (value) {
                      onCheckboxChanged(value ?? false);
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Quantity: ${item.quantity}",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    color: theme.iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: theme.iconTheme.color,
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
