package com.example.kalansage.model.userAction;


import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUserProgress;
    @Enumerated(EnumType.STRING)
    private ProgressStatus status;
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateProgress;
    @Column(name = "points_earned", nullable = false)
    private int pointsGagne;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;


    @ManyToOne
    @JoinColumn(name = "modules_id")
    private Module modules;

    @ManyToOne
    @JoinColumn(name = "lecons_id")
    private Lecons lecons;


}
