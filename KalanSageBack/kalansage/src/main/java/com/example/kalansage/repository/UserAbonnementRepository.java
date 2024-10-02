package com.example.kalansage.repository;

import com.example.kalansage.model.userAction.UserAbonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserAbonnementRepository extends JpaRepository<UserAbonnement, Long> {

    UserAbonnement save(UserAbonnement userAbonnement);


}
