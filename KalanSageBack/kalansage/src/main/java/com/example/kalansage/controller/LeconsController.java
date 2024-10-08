package com.example.kalansage.controller;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.service.LeconsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/lecons")
public class LeconsController {

    @Autowired
    private LeconsService leconsService;

    @Autowired
    private LeconsRepository leconsRepository;

    @PostMapping("/creer-lecon")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Lecons> createLecon(@RequestBody Lecons lecons) {
        Lecons newLecon = leconsService.creerLecon(lecons);
        return ResponseEntity.ok(newLecon);
    }


    @PutMapping("/modifier-lecon/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Lecons> updateLecon(@PathVariable Long id, @RequestBody Lecons lecons) {
        Lecons updatedLecon = leconsService.modifierLecon(id, lecons);

        return ResponseEntity.ok(updatedLecon);
    }

    @DeleteMapping("/supprimer-lecon/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> deleteLecon(@PathVariable Long id) {
        leconsService.supprimerLecon(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("/count")
    public ResponseEntity<Long> countLecons() {
        long count = leconsRepository.count();
        return ResponseEntity.ok(count);
    }

    @GetMapping("/lecon-par/{id}")
    public ResponseEntity<Lecons> getLeconById(@PathVariable Long id) {
        Lecons lecon = leconsService.getLeconById(id);
        return ResponseEntity.ok(lecon);
    }


    @GetMapping("/list-lecons")
    public ResponseEntity<?> listerLecons() {
        return ResponseEntity.ok(leconsRepository.findAll());
    }
}
