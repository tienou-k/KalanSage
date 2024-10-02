package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ModulesDTO {
    private Long id;
    private String titre;
    private String description;
    private double prix;
    private String nomCategorie;
    private Date dateCreation;

}
