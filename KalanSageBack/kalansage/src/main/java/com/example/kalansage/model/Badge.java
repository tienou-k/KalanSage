package com.example.kalansage.model;

import com.example.kalansage.model.userAction.UserBadge;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "badge")
public class Badge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idBadge;
    private String nomBadge;
    private int seuilDePoints;


    @OneToMany(mappedBy = "badge")
    private List<UserBadge> userBadges;
}
