package com.example.kalansage.exception;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class ErrorResponse {
    private String error;
    private String message;


    public ErrorResponse(int i, String message) {
    }
}
