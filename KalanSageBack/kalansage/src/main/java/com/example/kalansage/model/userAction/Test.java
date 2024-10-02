package com.example.kalansage.model.userAction;

import com.example.kalansage.model.Module;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Test {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String questions;

    @OneToOne
    @JoinColumn(name = "modules_id")
    private Module modules;

}
