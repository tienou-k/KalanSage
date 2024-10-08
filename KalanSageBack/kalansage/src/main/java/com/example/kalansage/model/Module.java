package com.example.kalansage.model;

import com.example.kalansage.model.userAction.Test;
import com.example.kalansage.model.userAction.UserModule;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

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
    @Column(name = "id_module")
    private Long id;
    private String titre;
    private String description;
    private double prix;
    private Date dateCreation;
    private Integer pointGagnes;

    @ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @JsonBackReference(value = "module-categorie")
    private Categorie categorie;


    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference(value = "modules-userModules")
    private Set<UserModule> userModules = new HashSet<>();

    @OneToMany(mappedBy = "modules", cascade = CascadeType.ALL, orphanRemoval = true)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonManagedReference(value = "modules-evaluations")
    private Set<Evaluation> evaluations = new HashSet<>();

    @OneToOne(mappedBy = "modules")
    private Test test;

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @JsonManagedReference
    private Set<Lecons> lecons = new HashSet<>();

    public void add(Long idCategorie) {
        // Implementation here
    }
}
