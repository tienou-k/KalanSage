package com.example.kalansage.controller;

import com.example.kalansage.dto.CategorieDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.service.CategorieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admins/categories")
public class CategorieController {

    @Autowired
    private CategorieService categorieService;

    @Autowired
    private CategorieRepository categorieRepository;


    @PostMapping("/creer-categorie")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> ajouterCategorie(@RequestBody CategorieDTO categorieDTO) {
        try {
            Categorie newCategorie = categorieService.creerCategorie(categorieDTO);
            return ResponseEntity.ok(newCategorie);
        } catch (RuntimeException e) {
            return ResponseEntity.status(400).body(e.getMessage());
        }
    }


    @PutMapping("/modifier-categorie/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> modifierCategorie(@PathVariable Long id, @RequestBody Categorie categorie) {
        if (isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent modifier des cours");
        }
        return new ResponseEntity<>(categorieService.modifierCategorie(id, categorie), HttpStatus.OK);
    }

    @DeleteMapping("/supprimer-categorie/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> supprimerCategorie(@PathVariable Long id) {
        if (isAdmin()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent supprimer des cours");
        }

        categorieService.supprimerCategorie(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("/categorie-par/{id}")
    public ResponseEntity<?> getCategorie(@PathVariable Long id) {
        return ResponseEntity.ok(Optional.ofNullable(categorieService.getCategoriebyId(id)));
    }


    @GetMapping("/list-categories")
    public ResponseEntity<List<CategorieDTO>> listerCategorie() {
        List<CategorieDTO> categorieDTOs = categorieRepository.findAll().stream()
                .map(categorie -> new CategorieDTO(
                        categorie.getIdCategorie(),
                        categorie.getNomCategorie(),
                        categorie.getDescription()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(categorieDTOs);
    }

    private boolean isAdmin() {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        return !"ROLE_ADMIN".equalsIgnoreCase(currentUserRole);
    }
}
