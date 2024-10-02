package com.example.kalansage.dto;

import com.example.kalansage.model.FileInfo;
import jakarta.persistence.OneToOne;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
public class UtilisateurDTO {
    private String nom;
    private String prenom;
    private String email;
    private String username;
    private Boolean status;
    private String password;


    @OneToOne
    @EqualsAndHashCode.Exclude
    private FileInfo fileInfos;
}
