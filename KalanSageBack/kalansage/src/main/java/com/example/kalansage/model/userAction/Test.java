package com.example.kalansage.model.userAction;

import com.example.kalansage.model.Module;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Test {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String questions;

    /* @OneToOne
     @JoinColumn(name = "modules_id")
     @JsonBackReference
     private Module modules;*/
    @OneToOne
    @JoinColumn(name = "module_id")
    @JsonBackReference
    private Module module;

}
