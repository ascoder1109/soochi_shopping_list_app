package com.ascoder1109.soochi.dtos;

import lombok.Data;

@Data
public class UserRegistrationDTO {
    private String userName;
    private String email;
    private String password;
    public UserRegistrationDTO(String userName){
        this.userName = userName;
    }
}
