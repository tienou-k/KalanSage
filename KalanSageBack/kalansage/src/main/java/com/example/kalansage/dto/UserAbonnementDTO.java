package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserAbonnementDTO {

    private Long id;
    private Date startDate;
    private Date endDate;
    private UserDTO user;
    private AbonnementDTO abonnement;
    private boolean active;



}