package com.example.kalansage.model;

import com.example.kalansage.model.userAction.Test;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "MODULES")
public class Module {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long idModule;
    private String titre;
    private String description;
    private double prix;
    private Date dateCreation;
    private Integer PointGagnes;

    // Relation between Modules and Categorie
    @ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @JsonBackReference
    private Categorie categorie;


    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Lecons> lecons;


    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, orphanRemoval = true)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonManagedReference(value = "modules-evaluations")
    private Set<Evaluation> evaluations = new HashSet<>();


    @OneToOne(mappedBy = "modules")
    private Test test;

    public void add(Long idCategorie) {
    }
}
