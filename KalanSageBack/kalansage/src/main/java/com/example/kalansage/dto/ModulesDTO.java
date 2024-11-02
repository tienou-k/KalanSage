package com.example.kalansage.dto;

import com.example.kalansage.model.Module;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ModulesDTO extends Module {

    private Long id;
    private String titre;
    private String description;
    private double prix;
    private String imageUrl;
    private Date dateCreation;
    private String nomCategorie;
    private int leconsCount;
    private int modulesUsers;
    private Set<?> users;



}