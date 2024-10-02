package com.example.kalansage.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "utilisateur")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Utilisateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;
    private String prenom;

    @Column(unique = true)
    private String username;

    @Column(unique = true)
    private String email;

    private String motDePasse;
    private Date dateInscription;
    private boolean status;

    // -----------------------------Utilisateur role-----------------------------------
    @ManyToOne
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private Role role;

    // utilisateur evaluation-----------------------------------------
    @OneToOne
    @EqualsAndHashCode.Exclude
    private FileInfo fileInfos;

    //----------------------Constructor------------------------------------------
    public Utilisateur(Date dateInscription, String prenom, String nom, String username, String email, String motDePasse, Role role) {
        this.dateInscription = dateInscription;
        this.prenom = prenom;
        this.nom = nom;
        this.username = username;
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
