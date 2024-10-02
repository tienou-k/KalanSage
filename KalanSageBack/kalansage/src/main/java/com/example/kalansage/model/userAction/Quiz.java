package com.example.kalansage.model.userAction;

import com.example.kalansage.model.Lecons;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String questions;

    @ManyToOne
    @JoinColumn(name = "lecons_id")
    private Lecons lecons;


}
