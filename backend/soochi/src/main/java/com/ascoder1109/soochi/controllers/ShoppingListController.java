package com.ascoder1109.soochi.controllers;

import com.ascoder1109.soochi.dtos.ShoppingListDTO;
import com.ascoder1109.soochi.dtos.ShoppingListRequestDTO;
import com.ascoder1109.soochi.services.ShoppingListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shopping-lists")
public class ShoppingListController {

    @Autowired
    private ShoppingListService shoppingListService;


    @PostMapping
    public ResponseEntity<ShoppingListDTO> createShoppingList(@RequestBody ShoppingListRequestDTO shoppingListRequestDTO) {
        ShoppingListDTO shoppingListDTO = shoppingListService.createShoppingList(shoppingListRequestDTO);
        return new ResponseEntity<>(shoppingListDTO, HttpStatus.CREATED);
    }


    @GetMapping
    public ResponseEntity<List<ShoppingListDTO>> getAllShoppingLists() {
        List<ShoppingListDTO> shoppingLists = shoppingListService.getAllShoppingLists();
        return new ResponseEntity<>(shoppingLists, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ShoppingListDTO> getShoppingListById(@PathVariable Long id) {
        ShoppingListDTO shoppingListDTO = shoppingListService.getShoppingListById(id);
        return new ResponseEntity<>(shoppingListDTO, HttpStatus.OK);
    }


    @PutMapping("/{id}")
    public ResponseEntity<ShoppingListDTO> updateShoppingList(@PathVariable Long id, @RequestBody ShoppingListRequestDTO shoppingListRequestDTO) {
        ShoppingListDTO updatedShoppingList = shoppingListService.updateShoppingList(id, shoppingListRequestDTO);
        return new ResponseEntity<>(updatedShoppingList, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteShoppingList(@PathVariable Long id) {
        shoppingListService.deleteShoppingList(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
