package com.ascoder1109.soochi.dtos;

import lombok.Data;

@Data
public class UserLoginResponseDTO {
    private String token;
    public UserLoginResponseDTO(String token) {
        this.token = token;
    }
}
