package com.ascoder1109.soochi.controllers;

import com.ascoder1109.soochi.dtos.ItemDTO;
import com.ascoder1109.soochi.dtos.ItemUpdateDTO;
import com.ascoder1109.soochi.dtos.ItemCheckboxUpdateDTO;
import com.ascoder1109.soochi.services.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @GetMapping("/shopping-lists/{shoppingListId}")
    public ResponseEntity<List<ItemDTO>> getItemsByShoppingList(@PathVariable Long shoppingListId) {
        List<ItemDTO> items = itemService.getItemsForShoppingList(shoppingListId);
        return new ResponseEntity<>(items, HttpStatus.OK);
    }

    @PostMapping("/shopping-lists/{shoppingListId}")
    public ResponseEntity<ItemDTO> createItem(@PathVariable Long shoppingListId, @RequestBody ItemDTO itemDTO) {
        ItemDTO createdItem = itemService.createItem(shoppingListId, itemDTO);
        return new ResponseEntity<>(createdItem, HttpStatus.CREATED);
    }

    @PutMapping("/{itemId}")
    public ResponseEntity<ItemDTO> updateItem(@PathVariable Long itemId, @RequestBody ItemUpdateDTO itemUpdateDTO) {
        ItemDTO updatedItem = itemService.updateItem(itemId, itemUpdateDTO);
        return new ResponseEntity<>(updatedItem, HttpStatus.OK);
    }

    @PatchMapping("/{itemId}/checkbox")
    public ResponseEntity<ItemDTO> updateItemCheckbox(@PathVariable Long itemId, @RequestBody ItemCheckboxUpdateDTO itemCheckboxUpdateDTO) {
        ItemDTO updatedItem = itemService.updateItemCheckbox(itemId, itemCheckboxUpdateDTO);
        return new ResponseEntity<>(updatedItem, HttpStatus.OK);
    }

    @DeleteMapping("/{itemId}")
    public ResponseEntity<Void> deleteItem(@PathVariable Long itemId) {
        itemService.deleteItem(itemId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PatchMapping("/{itemId}/toggle")
    public ResponseEntity<ItemDTO> toggleItemCheckbox(@PathVariable Long itemId) {
        ItemDTO toggledItem = itemService.toggleItemCheckbox(itemId);
        return new ResponseEntity<>(toggledItem, HttpStatus.OK);
    }

}
