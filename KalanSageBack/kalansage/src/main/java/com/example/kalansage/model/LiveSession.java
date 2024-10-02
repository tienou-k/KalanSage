package com.example.kalansage.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "livesession")
public class LiveSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idLive;

    private String titreLive;
    private LocalDateTime dateDebut;
    private int dureeMinutes;

    // Relationship with Utilisateur via ParticipantLive
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}
