package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {

    private Long id;
    private String nom;
    private String prenom;
    private String username;
    private String email;
    private String telephone;
    private Date dateInscription;

}