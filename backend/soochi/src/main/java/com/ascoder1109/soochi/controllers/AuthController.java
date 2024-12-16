package com.ascoder1109.soochi.controllers;

import com.ascoder1109.soochi.dtos.UserLoginRequestDTO;
import com.ascoder1109.soochi.dtos.UserLoginResponseDTO;
import com.ascoder1109.soochi.dtos.UserRegistrationDTO;
import com.ascoder1109.soochi.services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Value("${auth.api.name}")
    private String authApiName;

    @Value("${auth.api.key}")
    private String authApiKey;

    @Autowired
    private AuthService authService;

    private boolean validateApiHeaders(String apiName, String apiKey) {
        return apiName == null || apiKey == null || !apiName.equals(authApiName) || !apiKey.equals(authApiKey);
    }

    @PostMapping("/register")
    public ResponseEntity<UserRegistrationDTO> register(
            @RequestHeader("API_NAME") String apiName,
            @RequestHeader("API_KEY") String apiKey,
            @RequestBody UserRegistrationDTO userRegistrationDTO) {


        if (!validateApiHeaders(apiName, apiKey)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new UserRegistrationDTO("Invalid API Name or API Key"));
        }


        UserRegistrationDTO response = authService.registerUser(userRegistrationDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }


    @PostMapping("/login")
    public ResponseEntity<UserLoginResponseDTO> login(@RequestHeader("API_NAME") String apiName, @RequestHeader("API_KEY") String apiKey,@RequestBody UserLoginRequestDTO userLoginRequestDTO) {

        if (!validateApiHeaders(apiName, apiKey)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new UserLoginResponseDTO("Invalid API Name or API Key"));
        }
        UserLoginResponseDTO response = authService.loginUser(userLoginRequestDTO);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}
