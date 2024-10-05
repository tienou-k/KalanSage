package com.example.kalansage.controller;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.service.LeconsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/lecons")
public class LeconsController {

    @Autowired
    private LeconsService leconsService;

    @Autowired
    private LeconsRepository leconsRepository;


    @PostMapping("/creer-lecon")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> creerModule(@RequestBody Lecons lecons) {
        if (!isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent créer des Lecons.");
        }
        return ResponseEntity.ok(leconsService.creerLecon(lecons));
    }


    @PutMapping("/modifier-lecon/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> modifierModule(@PathVariable Long id, @RequestBody Lecons lecons) {
        if (!isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent modifier des Lecons");
        }
        return new ResponseEntity<>(leconsService.modifierLecon(lecons), HttpStatus.OK);
    }

    // Delete a module (ADMIN only)
    @DeleteMapping("/supprimer-lecon/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> supprimerModule(@PathVariable Long id) {
        if (!isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent supprimer des Lecons.");
        }

        leconsService.supprimerLecon(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("/lecon-par/{id}")
    public ResponseEntity<?> getModule(@PathVariable Long id) {

        return ResponseEntity.ok(Optional.ofNullable(leconsService.getLeconById(id)));
    }

    // List all Lecons (ADMIN only)
    @GetMapping("/list-lecons")
    public ResponseEntity<?> listerLecons() {
        return ResponseEntity.ok(leconsRepository.findAll());
    }

    // Utility method to check if the current user is an ADMIN
    private boolean isAdmin() {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        return "ROLE_ADMIN".equalsIgnoreCase(currentUserRole);
    }
}
