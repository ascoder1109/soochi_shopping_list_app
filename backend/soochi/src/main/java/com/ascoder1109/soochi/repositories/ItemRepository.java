package com.ascoder1109.soochi.repositories;

import com.ascoder1109.soochi.models.Item;
import com.ascoder1109.soochi.models.ShoppingList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ItemRepository extends JpaRepository<Item,Long> {
    List<Item> findByShoppingList(ShoppingList shoppingList);
}
