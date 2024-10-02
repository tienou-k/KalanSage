package com.example.kalansage.service;

import com.example.kalansage.exception.UsernameNotFoundException;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.UserRepository;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.management.Notification;
import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {


    private final UserRepository userRepository;
    private UserService userService;


    @Autowired
    public UserServiceImpl(UserRepository userRepository,
                           EntityManager entityManager) {
        this.userRepository = userRepository;
    }

    @Override
    public User creerCompte(User user) {
        // Vérifier si l'utilisateur existe déjà
        Optional<User> existingUser = userRepository.findByEmailOrUsername(user.getEmail(), user.getUsername());
        if (existingUser.isPresent()) {
            throw new IllegalStateException("User déjà existant");
        }
        return userRepository.save(user);
    }

    @Override
    public void supprimerCompte(Long idUser) {
        if (userRepository.existsById(idUser)) {
            userRepository.deleteById(idUser);
        } else {
            throw new IllegalArgumentException("User introuvable avec l'ID : " + idUser);
        }
    }

    public User seConnecter(String email, String motDePasse) {
        User user = null;
        try {
            user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new UsernameNotFoundException("Utilisateur introuvable avec l'email : " + email));
        } catch (UsernameNotFoundException e) {
            throw new RuntimeException(e);
        }
        if (!user.getMotDePasse().equals(motDePasse)) {
            try {
                throw new UsernameNotFoundException("Informations d'identification incorrectes");
            } catch (UsernameNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
        return user;
    }

    @Override
    public void seDeconnecter() {

    }


    @Override
    public Optional<User> getUtilisateur(String Nom) {
        return userRepository.findByUsername(Nom);
    }

    @Override
    public Optional<User> getUser(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> trouverParEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User trouverParUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable avec le nom d'utilisateur : " + username));
    }

    @Override
    public List<User> listerUsers() {
        return userRepository.findAll();
    }


    @Override
    public void recevoirNotification(Long id, Notification notification) {
        // Implement notification handling logic here
    }

    @Override
    public User getUserById(Long userId) {
        return userService.getUserById(userId);
    }

    @Override
    public boolean hasComplete(User user, Module modules) {
        return false;
    }


}
