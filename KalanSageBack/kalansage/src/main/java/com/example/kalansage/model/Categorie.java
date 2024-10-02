package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Categorie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idCategorie;
    private String nomCategorie;
    private String Description;

    @OneToMany(mappedBy = "categorie",
            cascade = {CascadeType.PERSIST,
                    CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Module> modules;


}
