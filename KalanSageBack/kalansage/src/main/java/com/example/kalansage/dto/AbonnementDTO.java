package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AbonnementDTO {
    private Long idAbonnement;
    private String typeAbonnement;
    private String Description;
    private double prix;
    private Date dateExpiration;
    private Boolean statut;


}