package com.example.kalansage.service;

import com.example.kalansage.model.Paiement;
import com.example.kalansage.repository.PaiementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PaiementServiceImpl implements PaiementService {

    @Autowired
    private PaiementRepository paiementRepository;

    @Override
    public Paiement savePaiement(Paiement paiement) {
        return paiementRepository.save(paiement);
    }

    @Override
    public Optional<Paiement> getPaiementById(Long id) {
        return paiementRepository.findById(id);
    }

    @Override
    public List<Paiement> getAllPaiements() {
        return paiementRepository.findAll();
    }

    @Override
    public Paiement updatePaiement(Long id, Paiement paiement) {
        Optional<Paiement> existingPaiement = paiementRepository.findById(id);
        if (existingPaiement.isPresent()) {
            Paiement updatedPaiement = existingPaiement.get();
            updatedPaiement.setMontant(paiement.getMontant());
            updatedPaiement.setModePaiement(paiement.getModePaiement());
            updatedPaiement.setDate(paiement.getDate());
            return paiementRepository.save(updatedPaiement);
        }
        return null;
    }

    @Override
    public void deletePaiement(Long id) {
        paiementRepository.deleteById(id);
    }
}