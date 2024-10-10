package com.example.kalansage.controller;


import com.example.kalansage.dto.ModuleResponseDTO;
import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.service.LeconsService;
import com.example.kalansage.service.ModuleService;
import com.example.kalansage.service.ModuleServiceImpl;
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
    private LeconsRepository leconsRepository;
    @Autowired
    private LeconsService leconsService;

    @Autowired
    private CategorieRepository categorieRepository;
    @Autowired
    private ModuleServiceImpl moduleServiceimpl;


    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/creer-module")
    public ResponseEntity<?> creerModule(@RequestBody ModulesDTO modulesDTO) {
        try {
            Module createdModule = modulesservice.creerModule(modulesDTO);
            return new ResponseEntity<>(createdModule, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }


    @PutMapping("/modifier-module/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> modifierModule(@PathVariable Long id, @RequestBody ModulesDTO modulesDTO) {
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        if (!"ROLE_ADMIN".equalsIgnoreCase(currentUserRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seuls les ADMIN peuvent modifier des modules.");
        }
        try {
            Module modifierModule = modulesservice.modifierModule(id, modulesDTO);

            // Convert the entity to DTO to avoid recursion issues
            ModuleResponseDTO responseDTO = new ModuleResponseDTO();
            responseDTO.setId(modifierModule.getId());
            responseDTO.setTitre(modifierModule.getTitre());
            responseDTO.setDescription(modifierModule.getDescription());
            responseDTO.setPrix(modifierModule.getPrix());

            return ResponseEntity.ok(responseDTO);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }


    @DeleteMapping("/supprimer-module/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
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

    @PostMapping("/inscris-module/{userId}/{moduleId}")

    public ResponseEntity<?> enrollUserInModule(@PathVariable Long userId, @PathVariable Long moduleId) {
        try {
            UserModule userModule = moduleServiceimpl.inscrireAuModule(userId, moduleId);
            return ResponseEntity.ok(userModule);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/top5")
    public ResponseEntity<List<Module>> getTop5Modules() {
        List<Module> topModules = moduleServiceimpl.getTop5Modules();
        return ResponseEntity.ok(topModules);
    }

    @GetMapping("/module/{moduleId}/lecons")
    public ResponseEntity<List<Lecons>> getLeconsByModule(@PathVariable Long moduleId) {
        List<Lecons> leconsList = leconsService.findByModule_Id(moduleId);
        return ResponseEntity.ok(leconsList);
    }


}
