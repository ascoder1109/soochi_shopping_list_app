package com.ascoder1109.soochi.controller;

import com.ascoder1109.soochi.model.Item;
import com.ascoder1109.soochi.model.User;
import com.ascoder1109.soochi.service.ItemService;
import com.ascoder1109.soochi.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private UserService userService;

    // Create a new item
    @PostMapping
    public ResponseEntity<Item> createItem(@AuthenticationPrincipal UserDetails userDetails, @RequestBody Item item) {
        User user = userService.findByEmail(userDetails.getUsername());
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        item.setUser(user); // Set the logged-in user
        Item savedItem = itemService.saveItem(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedItem);
    }

    // Retrieve items for the logged-in user
    @GetMapping
    public ResponseEntity<List<Item>> getItemsForCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByEmail(userDetails.getUsername());
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<Item> items = itemService.getItemsByUserId(user.getId());
        return ResponseEntity.ok(items);
    }

    // Retrieve items for a specific user
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Item>> getItemsByUserId(@PathVariable Long userId) {
        List<Item> items = itemService.getItemsByUserId(userId);
        return ResponseEntity.ok(items);
    }

    // Update an existing item
    @PutMapping("/{itemId}")
    public ResponseEntity<Item> updateItem(@PathVariable Long itemId, @RequestBody Item item) {
        // You might want to check if the item exists and belongs to the user
        item.setId(itemId); // Set the item ID for update
        Item updatedItem = itemService.updateItem(item);
        return ResponseEntity.ok(updatedItem);
    }

    // Delete an item by ID
    @DeleteMapping("/{itemId}")
    public ResponseEntity<Void> deleteItem(@PathVariable Long itemId) {
        itemService.deleteItem(itemId);
        return ResponseEntity.noContent().build();
    }
}
