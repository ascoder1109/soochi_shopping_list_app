package com.ascoder1109.soochi.services;

import com.ascoder1109.soochi.dtos.UserDetailsDTO;
import com.ascoder1109.soochi.models.User;
import com.ascoder1109.soochi.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;


    public UserDetailsDTO getUserDetails() {

        String username = ((UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUsername();

        User user = userRepository.findByEmail(username)
                .orElseThrow(() -> new RuntimeException("User not found"));


        return new UserDetailsDTO(user.getUserName(), user.getEmail());
    }
}