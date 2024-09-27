package com.ascoder1109.soochi.controller;

import com.ascoder1109.soochi.dto.LoginRequest;
import com.ascoder1109.soochi.dto.RegistrationRequest;
import com.ascoder1109.soochi.model.User;
import com.ascoder1109.soochi.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody RegistrationRequest registrationRequest) {
        // Check if the user already exists
        if (userService.findByEmail(registrationRequest.getEmail()) != null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email already exists");
        }

        User user = new User();
        user.setEmail(registrationRequest.getEmail());
        user.setPassword(registrationRequest.getPassword());
        user.setName(registrationRequest.getName());

        userService.registerUser(user);
        return ResponseEntity.status(HttpStatus.CREATED).body("User registered successfully");
    }

    @PostMapping("/login")
    public ResponseEntity<Object> loginUser(@RequestBody LoginRequest loginRequest) {
        User user = userService.findByEmail(loginRequest.getEmail());
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
        }

        // Check if the password matches
        if (userService.getPasswordEncoder().matches(loginRequest.getPassword(), user.getPassword())) {
            // Create a JSON response directly, including the user's ID
            return ResponseEntity.ok(Map.of(
                    "message", "Login successful",
                    "id", user.getId(), // Add user ID to the response
                    "name", user.getName(),
                    "email", user.getEmail()
            ));
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }

    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        // Assuming you're using Spring Security with UserDetails
        User user = userService.findByEmail(userDetails.getUsername());

        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        return ResponseEntity.ok(user);
    }
}
