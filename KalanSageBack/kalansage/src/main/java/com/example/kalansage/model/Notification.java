package com.example.kalansage.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        private String message;
        private LocalDateTime dateEnvoie;

        @ManyToOne
        @JoinColumn(name = "user_id")
        private Utilisateur utilisateur;


}
