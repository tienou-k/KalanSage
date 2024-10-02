package com.example.kalansage.service;

import com.example.kalansage.model.Statistique;

import java.util.List;
import java.util.Optional;

public interface StatistiqueService {
    Statistique saveStatistique(Statistique statistique);
    Optional<Statistique> getStatistiqueById(Long id);
    List<Statistique> getAllStatistiques();
    Statistique updateStatistique(Long id, Statistique statistique);
    void surpprimerStatistique(Long id);
}
