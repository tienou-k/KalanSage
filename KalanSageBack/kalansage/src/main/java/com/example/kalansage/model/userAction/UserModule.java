package com.example.kalansage.model.userAction;

import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "user_modules")
public class UserModule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Temporal(TemporalType.DATE)
    @Column(name = "inscription_date")
    private Date dateInscription;

    @Column(name = "is_completed", nullable = false)
    private boolean isCompleted;

    @Temporal(TemporalType.DATE)
    @Column(name = "completion_date")
    private Date completionDate;

    @Column(name = "progress", nullable = false)
    private int progress;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;


    @ManyToOne
    @JoinColumn(name = "module_id", nullable = false)
    @JsonIgnore
    private Module module;
}
