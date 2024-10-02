package com.example.kalansage.controller;


import com.example.kalansage.model.Role;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.RoleRepository;
import com.example.kalansage.repository.UtilisateurRepository;
import com.example.kalansage.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.management.relation.RoleNotFoundException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/admins/")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @Autowired
    private UtilisateurRepository utilisateurRepository;
    @Autowired
    private RoleRepository roleRepository;

    @PostMapping("/creer-role")
    public ResponseEntity<String> creerRole(@RequestBody Role role) {
        try {
            roleService.creerRole(role);
            return ResponseEntity.ok("Role créé avec succès");
        } catch (IllegalStateException e) {
            // Catch the exception and return a 400 Bad Request with the message
            return ResponseEntity.badRequest().body("Role existe déjà");
        }
    }

    @PutMapping("/modifier-role/{id}")
    public String modifierRole(@PathVariable Long id, @RequestBody Role role, String message) {
        try {
            roleService.modifierRole(role);
            return "Role modifier avec succès";
        } catch (IllegalStateException e) {
            return "Role existe déjà";
        }
    }

    //-------------deleteRole --------------------------------
    @DeleteMapping("/supprimer-role/{idRole}")
    public String deleteRole(@PathVariable Long idRole) throws RoleNotFoundException {
        // Fetch the role to delete
        Optional<Role> roleToDelete = roleRepository.findById(idRole);
        if (roleToDelete.isEmpty()) {
            return ("Ce Role avec l'id " + idRole + " n'existe pas");
        }
        List<Utilisateur> utilisateurs = utilisateurRepository.findByRole(roleToDelete.get());
        Long defaultRoleId = 2L;
        Role newRole;
        Optional<Role> optionalDefaultRole = roleRepository.findById(defaultRoleId);
        if (optionalDefaultRole.isEmpty()) {
            newRole = new Role();
            newRole.setIdRole(defaultRoleId);
            newRole.setNomRole("DEFAULT_ROLE");
            newRole = roleRepository.save(newRole);
        } else {
            newRole = optionalDefaultRole.get();
        }
        for (Utilisateur utilisateur : utilisateurs) {
            utilisateur.setRole(newRole);
            utilisateurRepository.save(utilisateur);
        }
        roleService.supprimerRole(idRole);
        return ("Role avec l'id " + idRole + " supprimé avec succès, et les utilisateurs ont été réassignés au rôle par défaut.");
    }


    //-------------getRole par id---------------------------------
    @GetMapping("/role-par/{id}")
    public ResponseEntity<Optional<Role>> getRole(@PathVariable Long id) {
        return ResponseEntity.ok(roleService.getRole(id));
    }

    // -----------------Tous les roles---------------------------------------
    @GetMapping("/list-roles")
    public ResponseEntity<List<Role>> listerRoles() {
        return ResponseEntity.ok(roleRepository.findAll());
    }
}
