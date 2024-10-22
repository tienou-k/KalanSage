package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

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
    private Date dateAjout;
    private Date dateModification;
    private String videoPath;


    @ManyToOne
    @JoinColumn(name = "module_id", nullable = false)
    @JsonBackReference
    private Module module;

    @OneToOne(mappedBy = "lecon", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private Quiz quiz;


    @PrePersist
    protected void onCreate() {
        this.dateAjout = new Date();
    }
    @PreUpdate
    protected void onUpdate() {
        this.dateModification = new Date();
    }
}
