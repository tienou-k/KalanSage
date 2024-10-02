package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "abonnement")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Abonnement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAbonnement;
    private String typeAbonnement;
    private String Description;
    private double prix;
    private Date dateExpiration;
    private Boolean statut;


    //
    @ManyToMany(mappedBy = "abonnementUser")
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonIgnore
    private Set<User> abonne = new HashSet<>();


}
