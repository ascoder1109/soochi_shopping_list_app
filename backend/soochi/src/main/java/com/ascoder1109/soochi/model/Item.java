package com.ascoder1109.soochi.model;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "items")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private boolean checked;

    @ManyToOne // Many items belong to one user
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}