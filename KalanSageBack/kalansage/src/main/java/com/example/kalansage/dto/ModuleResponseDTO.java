package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ModuleResponseDTO {
    private Long id;
    private String titre;
    private String description;
    private double prix;
}
