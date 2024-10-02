package com.example.kalansage.model.userAction;


import com.example.kalansage.model.Lecons;
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
public class UserLecon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUserModule;
    @Temporal(TemporalType.TIMESTAMP)
    private Date completionDate;
    private int PointsGagnes;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "lecons_id", nullable = false)
    private Lecons lecons;


}
