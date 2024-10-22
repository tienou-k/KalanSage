package com.example.kalansage.controller;

import com.example.kalansage.dto.CategorieDTO;
import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.service.CategorieService;
import com.example.kalansage.service.ModuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/categories")
public class CategorieController {

    @Autowired
    private CategorieService categorieService;
    @Autowired
    private ModuleService modulesservice;
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


    // Get modules by category ID
    @GetMapping("/{id}/modules")
    public ResponseEntity<?> getModulesListInCategorie(@PathVariable Long id) {
        if (id == null || id <= 0) {
            return ResponseEntity.badRequest().body("Invalid category ID.");
        }

        List<Module> modules = modulesservice.getModulesByCategory_Id(id);

        if (modules.isEmpty()) {
            // Log the event here, if necessary
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body("No modules found for category ID: " + id);
        }

        // Map the list of Module entities to a list of ModulesDTO
        List<ModulesDTO> modulesDTO = modules.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(modulesDTO);
    }

    private ModulesDTO convertToDTO(Module module) {
        if (module == null) {
            return null;
        }
        return new ModulesDTO(
                module.getId(),
                module.getTitre(),
                module.getDescription(),
                module.getPrix(),
                module.getImageUrl(),
                module.getDateCreation(),
                module.getCategorie().getNomCategorie()
        );
    }


    @GetMapping("/{id}/modules/count")
    public ResponseEntity<?> getModulesCountInCategorie(@PathVariable Long id) {
        try {
            Optional<Categorie> categoryOptional = categorieRepository.findById(id);
            if (categoryOptional.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Catégorie non trouvée avec l'ID : " + id);
            }
            int moduleCount = categorieService.getModulesCountInCategorie(id);
            return ResponseEntity.ok().body(Collections.singletonMap("moduleCount", moduleCount));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Une erreur s'est produite : " + e.getMessage());
        }
    }


    private boolean isAdmin() {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        return !"ROLE_ADMIN".equalsIgnoreCase(currentUserRole);
    }
}
