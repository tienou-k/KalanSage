package com.example.kalansage.service;

import com.example.kalansage.model.Paiement;

import java.util.List;
import java.util.Optional;

public interface PaiementService {
    Paiement savePaiement(Paiement paiement);
    Optional<Paiement> getPaiementById(Long id);
    List<Paiement> getAllPaiements();
    Paiement updatePaiement(Long id, Paiement paiement);
    void deletePaiement(Long id);
}
