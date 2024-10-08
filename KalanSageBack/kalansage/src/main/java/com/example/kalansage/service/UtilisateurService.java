package com.example.kalansage.service;


import com.example.kalansage.model.Utilisateur;

import javax.management.Notification;
import java.util.List;
import java.util.Optional;

public interface UtilisateurService {

    Utilisateur seConnecter(String username, String motDePasse);

    void seDeconnecter(String token);

    Utilisateur creerCompte(Utilisateur utilisateur);

    void supprimerCompte(Long idUtilisateur);

    Optional<Utilisateur> getUtilisateur(String id);

    Optional<Utilisateur> getUtilisateur(Long id);

    Optional<Utilisateur> trouverParEmail(String email);

    Utilisateur trouverParUsername(String username);

    List<Utilisateur> listerUtilisateurs();

    void recevoirNotification(Long id, Notification notification);

    Utilisateur findByEmail(String currentUserEmail);

    Optional<Utilisateur> findById(Long id);

    Utilisateur save(Utilisateur utilisateur);
}
