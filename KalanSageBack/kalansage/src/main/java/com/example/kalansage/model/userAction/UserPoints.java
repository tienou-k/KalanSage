package com.example.kalansage.model.userAction;


import com.example.kalansage.model.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class UserPoints {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)

    private Long idPoints;
    private int totalPoints;


    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

}
