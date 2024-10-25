package com.example.kalansage.service;

import com.example.kalansage.exception.UsernameNotFoundException;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.UserRepository;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;


import javax.management.Notification;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private JavaMailSender mailSender;
    private final UserRepository userRepository;
    private UserService userService;
    @Autowired
    private PasswordEncoder passwordEncoder;


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
    public User getUser(Long id) {
        return userService.getUser(id);
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
    public boolean hasComplete(User user, Module modules) {
        return false;
    }

    public String generateResetToken(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isPresent()) {
            String token = UUID.randomUUID().toString();
            // Save token in the database with an expiration time if necessary
            //user.get().setResetToken(token);
           // userRepository.save(user.get());
            return token;
        }
        return null;
    }

    public void sendPasswordResetEmail(String email, String token) {
        String resetLink = "http://yourapp.com/reset-password?token=" + token; // Modify with your frontend link
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Demande de réinitialisation du mot de passe");
        message.setText("Pour réinitialiser votre mot de passe, cliquez sur le lien ci-dessous:\n" + resetLink);
        mailSender.send(message);
    }

    public boolean resetPassword(String token, String newPassword) {
        Optional<User> userOptional = userRepository.findByResetToken(token);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setMotDePasse(passwordEncoder.encode(newPassword));
            user.setResetToken(null); // Clear the token after use
            userRepository.save(user);
            return true;
        }
        return false;
    }

}
