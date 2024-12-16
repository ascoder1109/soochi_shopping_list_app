package com.ascoder1109.soochi.dtos;

import lombok.Data;

@Data
public class UserDetailsDTO {
    private String username;
    private String email;
    public UserDetailsDTO(String username, String email) {
        this.username = username;
        this.email = email;
    }
}
