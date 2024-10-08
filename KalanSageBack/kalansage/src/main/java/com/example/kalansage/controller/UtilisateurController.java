package com.example.kalansage.controller;


import com.example.kalansage.model.Role;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.FileInfoRepository;
import com.example.kalansage.repository.RoleRepository;
import com.example.kalansage.repository.UtilisateurRepository;
import com.example.kalansage.service.UtilisateurService;
import com.example.kalansage.service.UtilisateurServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.management.Notification;
import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/api/admins/utilisateurs")
@PreAuthorize("hasRole('ROLE_ADMIN')")
public class UtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;
    @Autowired
    private UtilisateurServiceImpl utilisateurServiceimpl;
    @Autowired
    private FileInfoRepository fileInfoRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private UtilisateurRepository utilisateurRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;


    // ------------------------count utilisateurs ------------------------

    @GetMapping("/count")
    public ResponseEntity<Long> getUserCount() {
        long count = utilisateurServiceimpl.countUsers();
        return ResponseEntity.ok(count);
    }

    @PostMapping("/status/{id}")
    public ResponseEntity<?> changeStatus(@PathVariable Long id) {
        Optional<Utilisateur> utilisateurOptional = utilisateurRepository.findById(id);

        if (utilisateurOptional.isPresent()) {
            Utilisateur utilisateur = utilisateurOptional.get();
            utilisateur.setStatus(!utilisateur.getStatus());
            utilisateurRepository.save(utilisateur);

            return ResponseEntity.ok(" status changé! ");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("utilisateur non existant");
        }
    }


    // --------------cherche un utilisateur par id---------------------------------------------
    @GetMapping("/par-id/{id}")
    public ResponseEntity<Optional<Utilisateur>> getUtilisateur(@PathVariable Long id) {
        try {
            Optional<Utilisateur> utilisateur = utilisateurService.getUtilisateur(id);
            return ResponseEntity.ok(utilisateur);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    //-----------------------------------cherche un utilisateur par username---------------------------------------------
    @GetMapping("/par/{username}")
    public ResponseEntity<Utilisateur> getUtilisateurByUsername(@PathVariable String username) {
        return new ResponseEntity<>(utilisateurService.trouverParUsername(username), HttpStatus.OK);
    }

    //-----------------------------------list des utilisateurs------------------------------------------------
    @GetMapping("/list-utilisateurs")
    public ResponseEntity<List<Utilisateur>> getAllUtilisateurs() {
        return new ResponseEntity<>(utilisateurService.listerUtilisateurs(), HttpStatus.OK);
    }


    //-----------------------------------recevoir une notification---------------------------------------------
    @GetMapping("/{id}/notifications")
    public ResponseEntity<Void> recevoirNotification(@PathVariable Long id, @RequestBody Notification notification) {
        utilisateurService.recevoirNotification(id, notification);
        return ResponseEntity.ok().build();
    }

    //-----------------------------------list des utilisateurs par role---------------------------------------------
    @GetMapping("/role/{nomRole}")
    public ResponseEntity<List<Utilisateur>> getUtilisateursByRole(@PathVariable String nomRole) {
        Optional<Role> role = roleRepository.findRoleByNomRole(nomRole);
        if (role.isPresent()) {
            List<Utilisateur> utilisateurs = utilisateurRepository.findByRole(role.get());
            return ResponseEntity.ok(utilisateurs);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    //-----------------------------------trouver un utilisateur par email---------------------------------------------
    @GetMapping("/email/{email}")
    public ResponseEntity<String> getUtilisateurByEmail(@PathVariable String email) {
        Optional<Utilisateur> utilisateur = utilisateurRepository.findByEmail(email);
        return utilisateur.map(value -> ResponseEntity.ok(value.toString())).orElseGet(()
                -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Utilisateur avec " + email + "  porté disparu !."));
    }

    //-------------------------suprimmer utilisateur---------------------------------------

    @DeleteMapping("/supprimer-utilisateur/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> supprimerUtilisateur(@PathVariable Long id) {
        utilisateurService.supprimerCompte(id);
        return ResponseEntity.noContent().build();
    }
}


