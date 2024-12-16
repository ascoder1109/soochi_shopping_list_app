package com.ascoder1109.soochi.repositories;

import com.ascoder1109.soochi.models.ShoppingList;
import com.ascoder1109.soochi.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShoppingListRepository extends JpaRepository<ShoppingList, Long> {
    List<ShoppingList> findByUser(User user);
}
