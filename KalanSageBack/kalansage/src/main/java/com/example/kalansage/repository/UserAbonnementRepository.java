package com.example.kalansage.repository;

import com.example.kalansage.model.userAction.UserAbonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserAbonnementRepository extends JpaRepository<UserAbonnement, Long> {

    UserAbonnement save(UserAbonnement userAbonnement);

    Optional<UserAbonnement> findByUser_IdAndAbonnement_IdAbonnement(Long userId, Long abonnementId);
}
