package com.example.kalansage.repository;

import com.example.kalansage.model.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AbonnementRepository extends JpaRepository<Abonnement, Long> {
    // Recherche par type d'abonnement
    boolean existsByTypeAbonnement(String typeAbonnement);

    // Recherche par statut
    List<Abonnement> findByStatut(Boolean statut);

    @Query("SELECT a FROM Abonnement a ORDER BY SIZE(a.abonne) DESC")
    Abonnement findMostSubscribedAbonnement();


}