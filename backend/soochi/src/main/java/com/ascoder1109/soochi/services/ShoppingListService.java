package com.ascoder1109.soochi.services;

import com.ascoder1109.soochi.dtos.ShoppingListDTO;
import com.ascoder1109.soochi.dtos.ShoppingListRequestDTO;
import com.ascoder1109.soochi.models.ShoppingList;
import com.ascoder1109.soochi.models.User;
import com.ascoder1109.soochi.repositories.ShoppingListRepository;
import com.ascoder1109.soochi.repositories.UserRepository;
import com.ascoder1109.soochi.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ShoppingListService {

    @Autowired
    private ShoppingListRepository shoppingListRepository;

    @Autowired
    private UserRepository userRepository;


    public ShoppingListDTO createShoppingList(ShoppingListRequestDTO requestDTO) {
        User currentUser = getCurrentUser();
        ShoppingList shoppingList = new ShoppingList();
        shoppingList.setName(requestDTO.getName());
        shoppingList.setUser(currentUser);
        shoppingList = shoppingListRepository.save(shoppingList);

        return toDTO(shoppingList);
    }


    public List<ShoppingListDTO> getAllShoppingLists() {
        User currentUser = getCurrentUser();
        List<ShoppingList> shoppingLists = shoppingListRepository.findByUser(currentUser);

        return shoppingLists.stream().map(this::toDTO).collect(Collectors.toList());
    }


    public ShoppingListDTO getShoppingListById(Long id) {
        User currentUser = getCurrentUser();
        Optional<ShoppingList> shoppingListOptional = shoppingListRepository.findByUser(currentUser).stream()
                .filter(shoppingList -> shoppingList.getId().equals(id))
                .findFirst();

        if (shoppingListOptional.isEmpty()) {
            throw new RuntimeException("Shopping List not found or you don't have permission to access it.");
        }

        return toDTO(shoppingListOptional.get());
    }


    public ShoppingListDTO updateShoppingList(Long id, ShoppingListRequestDTO requestDTO) {
        User currentUser = getCurrentUser();
        Optional<ShoppingList> shoppingListOptional = shoppingListRepository.findByUser(currentUser).stream()
                .filter(shoppingList -> shoppingList.getId().equals(id))
                .findFirst();

        if (shoppingListOptional.isEmpty()) {
            throw new RuntimeException("Shopping List not found or you don't have permission to access it.");
        }

        ShoppingList shoppingList = shoppingListOptional.get();
        shoppingList.setName(requestDTO.getName());
        shoppingList = shoppingListRepository.save(shoppingList);

        return toDTO(shoppingList);
    }


    public void deleteShoppingList(Long id) {
        User currentUser = getCurrentUser();
        Optional<ShoppingList> shoppingListOptional = shoppingListRepository.findByUser(currentUser).stream()
                .filter(shoppingList -> shoppingList.getId().equals(id))
                .findFirst();

        if (shoppingListOptional.isEmpty()) {
            throw new RuntimeException("Shopping List not found or you don't have permission to access it.");
        }

        shoppingListRepository.delete(shoppingListOptional.get());
    }


    private ShoppingListDTO toDTO(ShoppingList shoppingList) {
        ShoppingListDTO dto = new ShoppingListDTO();
        dto.setId(shoppingList.getId());
        dto.setName(shoppingList.getName());
        return dto;
    }

    public User getCurrentUser() {
        CustomUserDetails customUserDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return customUserDetails != null ? userRepository.findByEmail(customUserDetails.getUsername()).orElse(null) : null;
    }
}
