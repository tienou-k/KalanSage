package com.example.kalansage.dto;


import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PasswordResetRequest {
    private String email;
    private String newPassword;


}
