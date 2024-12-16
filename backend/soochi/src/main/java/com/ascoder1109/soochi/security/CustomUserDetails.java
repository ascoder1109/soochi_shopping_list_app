package com.ascoder1109.soochi.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

public class CustomUserDetails implements UserDetails {

    private String username;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities) {
        this.username = username;
        this.password = password;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;  // Set your actual logic for account expiration
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;  // Set your actual logic for account lock
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;  // Set your actual logic for credentials expiration
    }

    @Override
    public boolean isEnabled() {
        return true;  // Set your actual logic for enabled state
    }
}
