package com.ascoder1109.soochi.exceptions;

public class PasswordMismatchException extends RuntimeException {
    public PasswordMismatchException(String message) {
        message = "Password mismatch";
    }
}
