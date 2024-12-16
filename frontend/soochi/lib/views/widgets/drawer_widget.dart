import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soochi/routes.dart';
import '../../core/dtos/shopping_list_dto.dart';
import '../../core/services/auth_service.dart';
import '../viewmodels/selected_shopping_list_view_model.dart';
import '../viewmodels/user_view_model.dart';
import '../viewmodels/shopping_list_view_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int? _selectedListId;

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final userDetails = userViewModel.userDetails;
    final isLoadingUser = userViewModel.isLoading;

    if (!isLoadingUser && userDetails == null) {
      userViewModel.fetchUserDetails();
    }



    final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context);
    final isLoadingShoppingLists = shoppingListViewModel.isLoading;
    final shoppingLists = shoppingListViewModel.shoppingLists;

    if (!isLoadingUser && !isLoadingShoppingLists && shoppingLists.isEmpty) {
      shoppingListViewModel.fetchShoppingLists();
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: isLoadingUser
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    userDetails?.username[0].toUpperCase() ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDetails?.username ?? 'Guest',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userDetails?.email ?? 'guest@example.com',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Shopping Lists
          if (isLoadingShoppingLists)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: shoppingLists.length,
                itemBuilder: (context, index) {
                  final shoppingList = shoppingLists[index];
                  final isSelected = _selectedListId == shoppingList.id;

                  return ListTile(
                    title: Text(shoppingList.name),
                    tileColor: isSelected ? Colors.blue.shade100 : null,
                    onTap: () {
                      setState(() {
                        _selectedListId = shoppingList.id;
                      });

                      final selectedShoppingListViewModel = Provider.of<SelectedShoppingListViewModel>(context, listen: false);
                      selectedShoppingListViewModel.selectShoppingList(shoppingList.id, shoppingList.name);

                      Navigator.pop(context);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Show dialog to update shopping list name
                            _showEditShoppingListDialog(context, shoppingList);
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Show confirmation dialog to delete the shopping list
                            _showDeleteConfirmationDialog(context, shoppingList.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Spacer to push the buttons to the bottom
          const Spacer(),

          // Buttons (Logout and Add Shopping List)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final authService = AuthService();
                    try {
                      await authService.logout();
                      Navigator.popAndPushNamed(context, Routes.login);
                    } catch (e) {
                      print('Error during logout: $e');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to logout')));
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddShoppingListDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Shopping List"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Method to show dialog for adding a shopping list
  Future<void> _showAddShoppingListDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shopping List'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter shopping list name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context, listen: false);
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                await shoppingListViewModel.addShoppingList(name);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Method to show dialog for editing a shopping list
  Future<void> _showEditShoppingListDialog(BuildContext context, ShoppingListDTO shoppingList) async {
    final TextEditingController nameController = TextEditingController(text: shoppingList.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shopping List'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter new shopping list name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context, listen: false);
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                await shoppingListViewModel.updateShoppingList(shoppingList.id, name);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Method to show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(BuildContext context, int shoppingListId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shopping List'),
        content: const Text('Are you sure you want to delete this shopping list?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final shoppingListViewModel = Provider.of<ShoppingListViewModel>(context, listen: false);
              await shoppingListViewModel.deleteShoppingList(shoppingListId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
