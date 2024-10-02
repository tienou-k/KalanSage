package com.example.kalansage.model;

import com.example.kalansage.model.userAction.Quiz;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

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
    @JoinColumn(name = "modules_id", nullable = false)
    @JsonBackReference
    private Module modules;


    @OneToMany(mappedBy = "lecons")
    private List<Quiz> quizzes;

    public Object orElseThrow(Object leconNotFound) {
        throw new RuntimeException((String) leconNotFound);
    }
}