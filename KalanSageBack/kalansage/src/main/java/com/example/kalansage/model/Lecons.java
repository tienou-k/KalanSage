package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "LECONS")
public class Lecons {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long idLecon;

    private String titre;

    private String description;

    private String contenu;


    @ManyToOne
    @JoinColumn(name = "module_id", nullable = false)
    @JsonBackReference
    private Module module;

}
