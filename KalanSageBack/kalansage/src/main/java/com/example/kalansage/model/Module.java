package com.example.kalansage.model;

import com.example.kalansage.model.userAction.Test;
import com.example.kalansage.model.userAction.UserModule;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
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
@JsonIgnoreProperties({"categorie"})
public class Module {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String titre;
    private String description;
    private double prix;
    private String imageUrl;
    private Date dateCreation;
    private Integer pointGagnes;
    private boolean isBookmarked = false;


    @ManyToOne
    @JoinColumn(name = "categorie_id", nullable = false)
    @JsonBackReference
    private Categorie categorie;

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private Set<Lecons> lecons = new HashSet<>();

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<UserModule> userModules = new HashSet<>();

    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private Set<Review> reviews = new HashSet<>();

    @OneToOne(mappedBy = "module")
    @JsonIgnore
    private Test test;

    //--------------------Module certificat--------------------------------
    @Override
    public String toString() {
        return "Module [id=" + id + ", titre=" + titre + ", description=" + description + ", prix=" + prix + "]";
    }

}
