package com.example.kalansage.controller;


import com.example.kalansage.model.Admin;
import com.example.kalansage.model.FileInfo;
import com.example.kalansage.model.Role;
import com.example.kalansage.repository.AdminRepository;
import com.example.kalansage.repository.RoleRepository;
import com.example.kalansage.service.AdminServiceImpl;
import com.example.kalansage.service.FilesStorageServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/admins")
public class AdminController {

    @Autowired
    private AdminServiceImpl adminService;

    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private AdminRepository adminRepository;
    @Autowired
    private FilesStorageServiceImpl filesStorageService;
    @Autowired
    private PasswordEncoder passwordEncoder;


    @PostMapping(path = "/creer-admin", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasRole('ADMIN')")  // Vérifie que l'utilisateur actuel est un ADMIN
    public ResponseEntity<?> creerAdmin(
            @RequestParam(value = "nom") String nom,
            @RequestParam(value = "prenom") String prenom,
            @RequestParam(value = "email") String email,
            @RequestParam(value = "username") String username,
            @RequestParam(value = "password") String password,
            @RequestParam(value = "role") String nomRole,
            @RequestParam(value = "status") Boolean status,
            @RequestParam(value = "file") MultipartFile file
    ) throws IOException {

        if (!"ADMIN".equalsIgnoreCase(nomRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Seul la creation d' Admin est autorisé  !");
        }
        Optional<Role> userRole = roleRepository.findRoleByNomRole("ADMIN");
        if (userRole.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Le rôle 'ADMIN' n'existe pas. Veuillez contacter un administrateur ");
        }

        Optional<Admin> existingUser = adminRepository.findByEmail(email);
        if (existingUser.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Un utilisateur avec cet email existe déjà.");
        }

        // Créer un nouveau admin avec les données fournies
        Admin admin = new Admin();
        admin.setNom(nom);
        admin.setPrenom(prenom);
        admin.setUsername(username);
        admin.setEmail(email);
        admin.setMotDePasse(passwordEncoder.encode(password));
        admin.setDateInscription(new Date());
        admin.setStatus(status);
        admin.setRole(userRole.get());
        if (file != null && !file.isEmpty()) {
            FileInfo fileInfo = filesStorageService.saveFile(file);
            admin.setFileInfos(fileInfo);

        }
        // Sauvegarder l'admin dans la base de données
        adminRepository.save(admin);
        return ResponseEntity.ok(admin);
    }


    @PutMapping("/modifier-admin/{id}")
    public ResponseEntity<Admin> modifierAdmin(@PathVariable Long id, @RequestBody Admin admin) {
        adminService.modifierAdmin(admin);// Ensure the ID is set
        return ResponseEntity.ok(adminService.modifierAdmin(admin));
    }

    @DeleteMapping("/spprimer-admin/{id}")
    public ResponseEntity<Void> supprimerAdmin(@PathVariable Long id) {
        adminService.supprimerAdmin(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/admin-par/{id}")
    public ResponseEntity<Optional<Admin>> getAdmin(@PathVariable Long id) {
        return ResponseEntity.ok(adminService.getAdmin(id));
    }

    @GetMapping("/list-admins")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Admin>> listerAdmins() {
        return ResponseEntity.ok(adminService.listerAdmins());
    }


}
