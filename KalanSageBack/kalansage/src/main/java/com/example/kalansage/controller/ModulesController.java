package com.example.kalansage.controller;


import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.service.ModuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/modules")
public class ModulesController {

    @Autowired
    private ModuleService modulesservice;

    @Autowired
    private ModuleRepository modulesRepository;

    @Autowired
    private CategorieRepository categorieRepository;


    @PostMapping("/creer-module")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> creerModule(@RequestBody ModulesDTO modulesDTO) {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        if (!"ROLE_ADMIN".equalsIgnoreCase(currentUserRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent créer des module.");
        }
        try {
            Module createdModules = modulesservice.creerModule(modulesDTO);
            return new ResponseEntity<>(createdModules, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }


    @PutMapping("/modifier-cour/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> modifierModule(@PathVariable Long id, @RequestBody Module modules) {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();

        if (!"ROLE_ADMIN".equalsIgnoreCase(currentUserRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent modifier des module");
        }
        return new ResponseEntity<>(modulesservice.modifierModule(id, modules), HttpStatus.OK);
    }


    @DeleteMapping("/supprimer-module/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> supprimerModule(@PathVariable Long id) {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        if (!"ROLE_ADMIN".equalsIgnoreCase(currentUserRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent supprimer des module.");
        }

        try {
            modulesservice.supprimerModule(id);
            return ResponseEntity.ok("Module supprimer avec succcès.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error de suppression.");
        }
    }


    @GetMapping("/module-par/{id}")
    public ResponseEntity<Optional<ModulesDTO>> getModule(@PathVariable Long id) {
        return ResponseEntity.ok(modulesservice.getModule(id));
    }


    @GetMapping("/list-modules")
    public ResponseEntity<List<ModulesDTO>> listerModules() {
        return ResponseEntity.ok(modulesservice.listerModule());
    }
}
