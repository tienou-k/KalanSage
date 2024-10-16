package com.example.kalansage.repository;



import com.example.kalansage.model.Role;
import com.example.kalansage.model.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UtilisateurRepository extends JpaRepository<Utilisateur, Long> {
    Optional<Utilisateur> findByEmail(String email);

    Optional<Utilisateur> findByUsername(String username);

    Optional<Utilisateur> findByEmailOrUsername(String email, String username);

    List<Utilisateur> findByRole(Role role);
}