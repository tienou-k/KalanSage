package com.example.kalansage.service;


import com.example.kalansage.model.Statistique;
import com.example.kalansage.repository.StatistiqueRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StatistiqueServiceImpl implements StatistiqueService {

    @Autowired
    private StatistiqueRepository statistiqueRepository;

    @Override
    public Statistique saveStatistique(Statistique statistique) {
        return statistiqueRepository.save(statistique);
    }

    @Override
    public Optional<Statistique> getStatistiqueById(Long id) {
        return statistiqueRepository.findById(id);
    }

    @Override
    public List<Statistique> getAllStatistiques() {
        return statistiqueRepository.findAll();
    }

    @Override
    public Statistique updateStatistique(Long id, Statistique statistique) {
        Optional<Statistique> existingStatistique = statistiqueRepository.findById(id);
        if (existingStatistique.isPresent()) {
            Statistique updatedStatistique = existingStatistique.get();
            updatedStatistique.setValue(statistique.getValue());
            updatedStatistique.setDateRecord(statistique.getDateRecord());
            updatedStatistique.setNomMetric(statistique.getNomMetric());
            return statistiqueRepository.save(updatedStatistique);
        }
        return null;
    }

    @Override
    public void surpprimerStatistique(Long id) {
        statistiqueRepository.deleteById(id);
    }
}