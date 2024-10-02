package com.example.kalansage.service;

import com.example.kalansage.exception.UsernameNotFoundException;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Override
    public UserDetails loadUserByUsername(String username) {
        Optional<Utilisateur> utilisateurOptional = utilisateurRepository.findByUsername(username);

        if (utilisateurOptional.isPresent()) {
            Utilisateur utilisateur = utilisateurOptional.get();

            // Vérifiez si l'utilisateur a un ID valide
            Long userId = utilisateur.getId();
            if (userId == null) {
                try {
                    throw new UsernameNotFoundException("L'ID de l'utilisateur pour " + username + " n'est pas présent dans la base de données.");
                } catch (UsernameNotFoundException e) {
                    throw new RuntimeException(e);
                }
            }

            String role = "ROLE_" + utilisateur.getRole().getNomRole();
            return new org.springframework.security.core.userdetails.User(
                    utilisateur.getUsername(),
                    utilisateur.getMotDePasse(),
                    Collections.singletonList(new SimpleGrantedAuthority(role))
            );
        } else {
            try {
                throw new UsernameNotFoundException("Vous cherchez un fantôme on dirait : " + username);
            } catch (UsernameNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
