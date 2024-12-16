package com.ascoder1109.soochi.services;

import com.ascoder1109.soochi.dtos.ItemCheckboxUpdateDTO;
import com.ascoder1109.soochi.dtos.ItemDTO;
import com.ascoder1109.soochi.dtos.ItemUpdateDTO;
import com.ascoder1109.soochi.models.Item;
import com.ascoder1109.soochi.models.ShoppingList;
import com.ascoder1109.soochi.models.User;
import com.ascoder1109.soochi.repositories.ItemRepository;
import com.ascoder1109.soochi.repositories.ShoppingListRepository;
import com.ascoder1109.soochi.repositories.UserRepository;
import com.ascoder1109.soochi.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ItemService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private ShoppingListRepository shoppingListRepository;

    public List<ItemDTO> getItemsForShoppingList(Long shoppingListId) {
        User currentUser = getCurrentUser();
        Optional<ShoppingList> shoppingListOptional = shoppingListRepository.findById(shoppingListId);

        if (shoppingListOptional.isEmpty() || !shoppingListOptional.get().getUser().equals(currentUser)) {
            throw new RuntimeException("Shopping list not found or you don't have permission to access it.");
        }

        ShoppingList shoppingList = shoppingListOptional.get();
        List<Item> items = itemRepository.findByShoppingList(shoppingList);

        return items.stream().map(this::toDTO).collect(Collectors.toList());
    }


    public ItemDTO createItem(Long shoppingListId, ItemDTO itemDTO) {
        User currentUser = getCurrentUser();
        Optional<ShoppingList> shoppingListOptional = shoppingListRepository.findById(shoppingListId);

        if (shoppingListOptional.isEmpty() || !shoppingListOptional.get().getUser().equals(currentUser)) {
            throw new RuntimeException("Shopping list not found or you don't have permission to add items.");
        }

        ShoppingList shoppingList = shoppingListOptional.get();

        Item item = new Item();
        item.setName(itemDTO.getName());
        item.setQuantity(itemDTO.getQuantity());
        item.setChecked(itemDTO.isChecked());
        item.setShoppingList(shoppingList);

        Item savedItem = itemRepository.save(item);
        return toDTO(savedItem);
    }



    public void deleteItem(Long itemId) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));
        itemRepository.delete(item);
    }

    public ItemDTO updateItem(Long itemId, ItemUpdateDTO itemUpdateDTO) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        if (itemUpdateDTO.getName() != null) {
            item.setName(itemUpdateDTO.getName());
        }
        if (itemUpdateDTO.getQuantity() != null) {
            item.setQuantity(itemUpdateDTO.getQuantity());
        }

        Item updatedItem = itemRepository.save(item);
        return toDTO(updatedItem);
    }


    public ItemDTO updateItemCheckbox(Long itemId, ItemCheckboxUpdateDTO itemCheckboxUpdateDTO) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        item.setChecked(itemCheckboxUpdateDTO.isChecked());
        Item updatedItem = itemRepository.save(item);
        return toDTO(updatedItem);
    }

    public ItemDTO toggleItemCheckbox(Long itemId) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        item.setChecked(!item.isChecked());  // Toggle the checkbox value
        Item updatedItem = itemRepository.save(item);
        return toDTO(updatedItem);
    }

    private ItemDTO toDTO(Item item) {
        ItemDTO dto = new ItemDTO();
        dto.setId(item.getId());
        dto.setName(item.getName());
        dto.setQuantity(item.getQuantity());
        dto.setChecked(item.isChecked());
        return dto;
    }


    public User getCurrentUser() {
        CustomUserDetails customUserDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return customUserDetails != null ? userRepository.findByEmail(customUserDetails.getUsername()).orElse(null) : null;
    }
}
