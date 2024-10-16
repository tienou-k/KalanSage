package com.example.kalansage.service;



import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.UtilisateurRepository;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;


    @SneakyThrows
    @Override
    public UserDetails loadUserByUsername(String email) {
        System.out.println("Attempting to find user with email: " + email);
        Optional<Utilisateur> utilisateurOptional = utilisateurRepository.findByEmail(email); // Use the correct method

        if (utilisateurOptional.isPresent()) {
            Utilisateur utilisateur = utilisateurOptional.get();

            // Verify if the user has a valid ID
            Long userId = utilisateur.getId();
            if (userId == null) {
                throw new UsernameNotFoundException("L'ID de l'utilisateur pour " + email + " n'est pas présent dans la base de données.");
            }

            String role = "ROLE_" + utilisateur.getRole().getNomRole();
            return new org.springframework.security.core.userdetails.User(
                    utilisateur.getEmail(),
                    utilisateur.getMotDePasse(),
                    Collections.singletonList(new SimpleGrantedAuthority(role))
            );
        } else {
            System.out.println("Attempting to find user with email: " + email);
            throw new UsernameNotFoundException("Utilisateur non trouvé avec l'adresse e-mail: " + email);
        }
    }

}
