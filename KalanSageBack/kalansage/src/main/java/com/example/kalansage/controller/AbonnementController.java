package com.example.kalansage.controller;


import com.example.kalansage.dto.AbonnementDTO;
import com.example.kalansage.exception.ErrorResponse;
import com.example.kalansage.model.Abonnement;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.AbonnementRepository;
import com.example.kalansage.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/admins/abonnements")
public class AbonnementController {

    @Autowired
    private AbonnementService abonnementService;
    @Autowired
    private AbonnementServiceImpl abonnementServiceimpl;
    @Autowired
    private UserInteractionService userInteractionService;
    @Autowired
    private ModuleServiceImpl moduleServiceimpl;

    @PostMapping("/creer-abonnement")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> creerAbonnement(@RequestBody AbonnementDTO abonnementDTO) {
        try {
            Abonnement newAbonnement = abonnementService.creerAbonnement(abonnementDTO);
            return ResponseEntity.ok(newAbonnement);
        } catch (RuntimeException e) {
            return ResponseEntity.status(400).body(e.getMessage());
        }
    }


    @PutMapping("/modifier-abonnement/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> modifierAbonnement(@PathVariable Long id, @RequestBody Abonnement abonnement) {
        if (isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Erreur de la modification");
        }
        return new ResponseEntity<>(abonnementService.modifierAbonnement(id, abonnement), HttpStatus.OK);
    }


    @DeleteMapping("/annuler-abonnement/{id}")
    public ResponseEntity<Void> annulerAbonnement(@PathVariable Long id) {
        abonnementService.annulerAbonnement(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/validerabonnement/{id}")
    public ResponseEntity<Abonnement> validerAbonnement(@PathVariable Long id) {
        Abonnement abonnement = abonnementService.validerAbonnement(id);
        return ResponseEntity.ok(abonnement);
    }

    @DeleteMapping("/supprimer-abonnement/{id}")
    public ResponseEntity<Void> supprimerAbonnement(@PathVariable Long id) {
        abonnementService.supprimerAbonnement(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/abonnement-par/{id}")
    public ResponseEntity<Optional<Abonnement>> getAbonnement(@PathVariable Long id) {
        return ResponseEntity.ok(abonnementService.getAbonnement(id));
    }

    @GetMapping("/list-abonnements")
    public ResponseEntity<List<Abonnement>> listerAbonnements() {
        return ResponseEntity.ok(abonnementService.listerAbonnements());
    }

    @GetMapping("/count")
    public ResponseEntity<Long> getAbonnementCount() {
        long count = userInteractionService.countAbonnements();
        return ResponseEntity.ok(count);
    }

    @GetMapping("/most-subscribed")
    public ResponseEntity<Object> getMostSubscribedAbonnement() {
        Abonnement mostSubscribed = userInteractionService.getMostSubscribedAbonnement();

        if (mostSubscribed != null) {
            return ResponseEntity.ok(mostSubscribed);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("message", "Aucun abonnement trouvé"));
        }
    }

    @GetMapping("/top5")
    public ResponseEntity<List<Module>> getTop5Modules() {
        List<Module> topModules = moduleServiceimpl.getTop5Modules();
        return ResponseEntity.ok(topModules);
    }


    @GetMapping("/users")
    public ResponseEntity<List<User>> getAbonnementUsers() {
        List<User> abonnementUsers = userInteractionService.getAbonnementUsers();
        return ResponseEntity.ok(abonnementUsers);
    }


    private boolean isAdmin() {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        return !"ROLE_ADMIN".equalsIgnoreCase(currentUserRole);
    }
}
