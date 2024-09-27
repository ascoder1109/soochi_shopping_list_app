package com.ascoder1109.soochi.dto;

import lombok.Data;

@Data
public class RegistrationRequest {
    private String email;
    private String password;
    private String name;
}