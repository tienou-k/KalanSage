package com.example.kalansage.model;

import com.example.kalansage.model.userAction.Test;
import com.example.kalansage.model.userAction.UserModule;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "MODULES")
public class Module {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String titre;
    private String description;
    private double prix;
    private Date dateCreation;
    private Integer pointGagnes;


    @ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @JsonBackReference
    private Categorie categorie;

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Lecons> lecons = new HashSet<>();

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<UserModule> userModules = new HashSet<>();

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<Evaluation> evaluations = new HashSet<>();

    @OneToOne(mappedBy = "module")
    @JsonIgnore
    private Test test;

    /*@ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @JsonIgnore
    private Categorie categorie;

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Lecons> lecons = new HashSet<>();

    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<UserModule> userModules = new HashSet<>();

    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<Evaluation> evaluations = new HashSet<>();

    @OneToOne(mappedBy = "module")
    @JsonIgnore
    private Test test;*/
}
