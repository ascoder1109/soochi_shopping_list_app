package com.ascoder1109.soochi.services;

import com.ascoder1109.soochi.dtos.UserLoginRequestDTO;
import com.ascoder1109.soochi.dtos.UserLoginResponseDTO;
import com.ascoder1109.soochi.dtos.UserRegistrationDTO;
import com.ascoder1109.soochi.exceptions.PasswordMismatchException;
import com.ascoder1109.soochi.exceptions.UserAlreadyExistsException;
import com.ascoder1109.soochi.exceptions.UserDoesNotExistException;
import com.ascoder1109.soochi.models.User;
import com.ascoder1109.soochi.repositories.UserRepository;
import com.ascoder1109.soochi.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Override
    public UserRegistrationDTO registerUser(UserRegistrationDTO userRegistrationDTO) {
        if (userRepository.findByEmail(userRegistrationDTO.getEmail()).isPresent()) {
            throw new UserAlreadyExistsException("User already exists");
        }
        User user = new User();
        user.setUserName(userRegistrationDTO.getUserName());
        user.setEmail(userRegistrationDTO.getEmail());
        user.setPassword(passwordEncoder.encode(userRegistrationDTO.getPassword()));
        userRepository.save(user);
        return new UserRegistrationDTO("User Registered Successfully: "+user.getUserName());

    }

    @Override
    public UserLoginResponseDTO loginUser(UserLoginRequestDTO userLoginRequestDTO) {
        String email = userLoginRequestDTO.getEmail();
        String password = userLoginRequestDTO.getPassword();

        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isEmpty()) {
            throw new UserDoesNotExistException("User doesn't exist");
        }
        User user = userOptional.get();

        if(!passwordEncoder.matches(password, user.getPassword())){
            throw new PasswordMismatchException("Password mismatch");
        }

        String token = jwtTokenProvider.generateToken(user);
        return new UserLoginResponseDTO(token);
    }
}
