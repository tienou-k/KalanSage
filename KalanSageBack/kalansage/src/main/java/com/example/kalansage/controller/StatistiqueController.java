package com.example.kalansage.controller;


import com.example.kalansage.model.Statistique;
import com.example.kalansage.service.StatistiqueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/statistiques")
public class StatistiqueController {

    @Autowired
    private StatistiqueService statistiqueService;

    @GetMapping
    public ResponseEntity<List<Statistique>> getAllStatistiques() {
        List<Statistique> statistiques = statistiqueService.getAllStatistiques();
        return ResponseEntity.ok(statistiques);
    }

    @PostMapping
    public ResponseEntity<Statistique> saveStatistique(@RequestBody Statistique statistique) {
        Statistique newStatistique = statistiqueService.saveStatistique(statistique);
        return ResponseEntity.status(HttpStatus.CREATED).body(newStatistique);
    }
}

