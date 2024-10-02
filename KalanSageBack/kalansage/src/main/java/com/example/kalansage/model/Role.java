package com.example.kalansage.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Collection;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long idRole;
    private String nomRole;

    @OneToMany(mappedBy = "role", cascade = CascadeType.REMOVE)
    @JsonIgnore
    private Collection<Utilisateur> utilisateur;

    public Role(String nomRole) {
        this.nomRole = nomRole;
    }
}
