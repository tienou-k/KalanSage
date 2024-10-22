package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "EVALUATION")
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long idEvaluation;
    private int etoiles;
    private String commentaire;


    @ManyToMany
    @JoinTable(
            name = "user_evaluation",
            joinColumns = @JoinColumn(name = "evaluation_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonIgnore
    private Set<User> users = new HashSet<>();


    /*@ManyToOne
    @JoinColumn(name = "modules_id")
    @JsonBackReference
    private Module modules;*/
    @ManyToOne
    @JoinColumn(name = "module_id", nullable = false)
    @JsonBackReference
    private Module module;


    public void setUserId(Long userId) {
    }
}