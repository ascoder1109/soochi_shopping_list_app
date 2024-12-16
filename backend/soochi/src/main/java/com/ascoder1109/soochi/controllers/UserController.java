package com.ascoder1109.soochi.controllers;

import com.ascoder1109.soochi.dtos.UserDetailsDTO;
import com.ascoder1109.soochi.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/details")
    public ResponseEntity<UserDetailsDTO> getUserDetails() {
        UserDetailsDTO userDetails = userService.getUserDetails();
        return ResponseEntity.status(HttpStatus.OK).body(userDetails);
    }
}
