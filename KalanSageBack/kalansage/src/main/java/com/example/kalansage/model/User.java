package com.example.kalansage.model;

import com.example.kalansage.model.userAction.ParticipantLive;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.model.userAction.UserPoints;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class User extends Utilisateur {
    private String resetToken;

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }
    public String getResetToken() {
        return resetToken;
    }

    //----------Utilisateur abonnement---------------------------------------
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_abonnement",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "abonnement_id")
    )
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private List<Abonnement> abonnementUser = new ArrayList<>();

    //---------------------Utilisateur module-----------------------------------------
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private Set<UserModule> userModules = new HashSet<>();

    //---------------------Utilisateur evaluation-----------------------------------------
    @ManyToMany
    @JoinTable(
            name = "user_review",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "review_id")
    )
    @JsonIgnore
    private Set<Review> reviews = new HashSet<>();

    //---------------------Utilisateur live session-----------------------------------------
    @OneToMany
    private Set<ParticipantLive> liveSessions;

    //---------------User - points--------------------------------------
    @OneToOne(mappedBy = "user")
    private UserPoints userPoints;

    //--------------------User certificates--------------------------------
    @OneToMany(mappedBy = "user")
    private List<Certificat> certificates;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<OTP> otps;
}
