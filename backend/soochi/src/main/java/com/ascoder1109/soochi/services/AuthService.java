package com.ascoder1109.soochi.services;

import com.ascoder1109.soochi.dtos.UserLoginRequestDTO;
import com.ascoder1109.soochi.dtos.UserLoginResponseDTO;
import com.ascoder1109.soochi.dtos.UserRegistrationDTO;

public interface AuthService {
    UserRegistrationDTO registerUser(UserRegistrationDTO userRegistrationDTO);
    UserLoginResponseDTO loginUser(UserLoginRequestDTO userLoginRequestDTO);
}
