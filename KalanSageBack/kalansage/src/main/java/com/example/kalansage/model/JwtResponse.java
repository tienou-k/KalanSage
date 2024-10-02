package com.example.kalansage.model;

import lombok.Data;

@Data
public class JwtResponse {
    private String token;
    private String message;

    public JwtResponse(String token, String message) {
        this.token = token;
        this.message = message;
    }
}
