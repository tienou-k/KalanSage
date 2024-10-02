package com.example.kalansage.service;

import com.example.kalansage.exception.UsernameNotFoundException;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.UtilisateurRepository;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.management.Notification;
import java.util.List;
import java.util.Optional;

@Service
public class UtilisateurServiceImpl implements UtilisateurService {


    private final UtilisateurRepository utilisateurRepository;

    @Autowired
    public UtilisateurServiceImpl(UtilisateurRepository utilisateurRepository,
                                  EntityManager entityManager) {
        this.utilisateurRepository = utilisateurRepository;
    }

    @Override
    public Utilisateur creerCompte(Utilisateur utilisateur) {
        // Vérifier si l'utilisateur existe déjà
        Optional<Utilisateur> existingUser = utilisateurRepository.findByEmailOrUsername(utilisateur.getEmail(), utilisateur.getUsername());
        if (existingUser.isPresent()) {
            throw new IllegalStateException("Utilisateur déjà existant");
        }
        return utilisateurRepository.save(utilisateur);
    }

    @Override
    public void supprimerCompte(Long idUser) {
        if (utilisateurRepository.existsById(idUser)) {
            utilisateurRepository.deleteById(idUser);
        } else {
            throw new IllegalArgumentException("User introuvable avec l'ID : " + idUser);
        }
    }

    public Utilisateur seConnecter(String email, String motDePasse) {
        Utilisateur utilisateur = null;
        try {
            utilisateur = utilisateurRepository.findByEmail(email)
                    .orElseThrow(() -> new UsernameNotFoundException("Utilisateur introuvable avec l'email : " + email));
        } catch (UsernameNotFoundException e) {
            throw new RuntimeException(e);
        }
        if (!utilisateur.getMotDePasse().equals(motDePasse)) {
            try {
                throw new UsernameNotFoundException("Informations d'identification incorrectes");
            } catch (UsernameNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
        return utilisateur;
    }

    @Override
    public void seDeconnecter() {

    }


    @Override
    public Optional<Utilisateur> getUtilisateur(String Nom) {
        return utilisateurRepository.findByUsername(Nom);
    }

    @Override
    public Optional<Utilisateur> getUtilisateur(Long id) {
        return utilisateurRepository.findById(id);
    }

    @Override
    public Optional<Utilisateur> trouverParEmail(String email) {
        return utilisateurRepository.findByEmail(email);
    }

    @Override
    public Utilisateur trouverParUsername(String username) {
        return utilisateurRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable avec le nom d'utilisateur : " + username));
    }

    @Override
    public List<Utilisateur> listerUtilisateurs() {
        return utilisateurRepository.findAll();
    }


    @Override
    public void recevoirNotification(Long id, Notification notification) {
        // Implement notification handling logic here
    }


}
