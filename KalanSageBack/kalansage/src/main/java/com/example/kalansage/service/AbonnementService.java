package com.example.kalansage.service;

import com.example.kalansage.dto.AbonnementDTO;
import com.example.kalansage.model.Abonnement;

import java.util.List;
import java.util.Optional;


public interface AbonnementService {

    Abonnement creerAbonnement(AbonnementDTO abonnementDTO);

    Abonnement modifierAbonnement(Long id, Abonnement updatedAbonnement);

    void annulerAbonnement(Long idAbonnement);

    Abonnement validerAbonnement(Long idAbonnement);

    void supprimerAbonnement(Long idAbonnement);

    Optional<Abonnement> getAbonnement(Long idAbonnement);

    List<Abonnement> listerAbonnements();


}
