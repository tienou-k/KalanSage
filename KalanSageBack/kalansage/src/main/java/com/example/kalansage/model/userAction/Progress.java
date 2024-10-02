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
@AllArgsConstructor
@NoArgsConstructor
public class Progress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idProgress;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "modules_id")
    private Module modules;

    @ManyToOne
    @JoinColumn(name = "lecons_id")
    private Lecons lecons;


    @Enumerated(EnumType.STRING)
    private ProgressStatus status; // IN_PROGRESS, COMPLETED

    @Temporal(TemporalType.TIMESTAMP)
    private Date progressDate;

    private int pointsEarned;


    public Progress(User user, Module modules, Lecons lecons, ProgressStatus status, Date progressDate, int pointsEarned) {
        this.user = user;
        this.modules = modules;
        this.lecons = lecons;
        this.status = status;
        this.progressDate = progressDate;
        this.pointsEarned = pointsEarned;
    }


}
