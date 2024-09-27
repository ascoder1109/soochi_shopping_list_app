import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Still needed for BoxShadow
import 'package:soochi/services/user_storage.dart'; // Import UserStorage
import 'package:soochi/model/user.dart';
import 'package:soochi/views/login_view.dart'; // Import the User model
// Import your login page

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Item> _items = [];
  User? _currentUser; // Variable to hold current user details
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    _currentUser = UserStorage.retrieveUser(); // Retrieve user details
  }

  void _showAddItemDialog() {
    String newItem = '';

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Add Item'),
          content: CupertinoTextField(
            placeholder: 'Enter item name',
            onChanged: (value) {
              newItem = value;
            },
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Add'),
              onPressed: () {
                if (newItem.isNotEmpty) {
                  setState(() {
                    _items.add(Item(
                        name: newItem,
                        checked: false)); // Add new item with checkbox state
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(int index) {
    String updatedItem = _items[index].name;

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Edit Item'),
          content: CupertinoTextField(
            placeholder: 'Update item name',
            onChanged: (value) {
              updatedItem = value;
            },
            controller: TextEditingController(
                text: updatedItem), // Pre-fill with current item name
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () {
                if (updatedItem.isNotEmpty) {
                  setState(() {
                    _items[index].name = updatedItem; // Update item name
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _logout() {
    // Handle logout logic here
    print("Logout clicked");
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => const LoginView()),
      (Route<dynamic> route) => false,
    );
  }

  void _reloadItems() {
    // Logic to reload items from the API or database
    print("Reloading items...");
    // You can add your API call logic here to fetch the items again
  }

  Future<bool> _onWillPop() async {
    final DateTime now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;
      return false; // Don't pop the page
    }
    return true; // Allow popping the page
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Column(
              children: [
                // Fixed navigation bar at the top
                CupertinoNavigationBar(
                  middle: Text('Hello ${_currentUser?.name ?? 'User'}!'),
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _reloadItems, // Call the reload function
                    child: const Icon(
                      CupertinoIcons.refresh,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ),
                // Scrollable content below the navigation bar
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return CupertinoCard(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                color: isDarkMode
                                    ? CupertinoColors.darkBackgroundGray
                                    : CupertinoColors.systemBackground,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CupertinoCheckbox(
                                          value: _items[index].checked,
                                          onChanged: (value) {
                                            setState(() {
                                              _items[index].checked =
                                                  value!; // Update checkbox state
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(_items[index].name),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () =>
                                              _showEditItemDialog(index),
                                          child: const Icon(
                                            CupertinoIcons.pencil,
                                            color: CupertinoColors.activeBlue,
                                          ),
                                        ),
                                        CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => _deleteItem(index),
                                          child: Icon(
                                            CupertinoIcons.delete,
                                            color: isDarkMode
                                                ? CupertinoColors.systemRed
                                                : CupertinoColors
                                                    .destructiveRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: _items.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Floating "+" button placed at the bottom-right of the screen
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: ClipOval(
                child: CupertinoButton(
                  onPressed: _showAddItemDialog,
                  color: CupertinoColors.activeBlue,
                  padding:
                      const EdgeInsets.all(16.0), // Adjust for circular size
                  child: const Icon(CupertinoIcons.add),
                  borderRadius: BorderRadius.circular(32.0), // Circular button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  String name;
  bool checked;

  Item({required this.name, required this.checked});
}

class CupertinoCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry margin;

  const CupertinoCard({
    required this.child,
    required this.color,
    required this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
