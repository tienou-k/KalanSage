package com.example.kalansage.exception;

// Exceptions personnalisées
public class UsernameAlreadyExistsException extends RuntimeException {
    public UsernameAlreadyExistsException(String message) {
        super(message);
    }
}

