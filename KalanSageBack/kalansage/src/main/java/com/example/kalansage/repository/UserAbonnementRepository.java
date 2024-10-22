package com.example.kalansage.repository;

import com.example.kalansage.model.Abonnement;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserAbonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserAbonnementRepository extends JpaRepository<UserAbonnement, Long> {

    UserAbonnement save(UserAbonnement userAbonnement);

    Optional<UserAbonnement> findByUser_IdAndAbonnement_IdAbonnement(Long userId, Long abonnementId);

    @Query("SELECT ua.abonnement FROM UserAbonnement ua GROUP BY ua.abonnement ORDER BY COUNT(ua.user) DESC")
    List<Abonnement> getMostSubscribedAbonnement();

    @Query("SELECT ua.user FROM UserAbonnement ua WHERE ua.abonnement.idAbonnement = :abonnementId")
    List<User> findUsersByAbonnementId(@Param("abonnementId") Long abonnementId);

}
