package com.example.kalansage.service;


import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;

import javax.management.Notification;
import java.util.List;
import java.util.Optional;

public interface UserService {
    User seConnecter(String username, String motDePasse);

    void seDeconnecter();

    User creerCompte(User user);

    void supprimerCompte(Long idUtilisateur);

    Optional<User> getUtilisateur(String id);

    Optional<User> getUser(Long id);

    Optional<User> trouverParEmail(String email);

    User trouverParUsername(String username);

    List<User> listerUsers();

    void recevoirNotification(Long id, Notification notification);

    User getUserById(Long userId);

    boolean hasComplete(User user, Module modules);
}
