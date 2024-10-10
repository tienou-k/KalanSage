package com.example.kalansage.controller;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.service.LeconsService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping(value = "/api/lecons", produces = "application/json")
public class LeconsController {

    @Autowired
    private LeconsService leconsService;

    @Autowired
    private LeconsRepository leconsRepository;
    @Autowired
    private ModuleRepository moduleRepository;

    @PostMapping(value = "/creer-lecon", consumes = "application/json", produces = "application/json")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> createLecon(@RequestBody Lecons lecon) {
        try {
            if (lecon.getModule() == null || lecon.getModule().getId() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Module information is missing.");
            }
            Optional<Module> module = moduleRepository.findById(lecon.getModule().getId());
            if (!module.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Module not found.");
            }
            lecon.setModule(module.get());
            Lecons nouvelleLecon = leconsService.creerLecon(lecon);
            return ResponseEntity.ok(nouvelleLecon);

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Module or related entity not found.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred while creating the lesson.");
        }
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
