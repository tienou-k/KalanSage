package com.example.kalansage.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "partenaire")
public class Partenaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPartenaire;

    private String nomPartenaire;
    private Date dateAjoute;
    private String typePartenaire;
    private String adresse;
    private String emailContact;
    private String numeroContact;
    private String descriptionPartenariat;
    private boolean status;

    @ElementCollection
    private List<String> certificationsAccordees;

    // partenaire evaluation-----------------------------------------
    @OneToOne
    @EqualsAndHashCode.Exclude
    private FileInfo fileInfos;
}

