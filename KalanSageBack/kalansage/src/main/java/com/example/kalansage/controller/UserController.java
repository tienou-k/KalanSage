package com.example.kalansage.controller;


import com.example.kalansage.dto.PasswordResetRequest;
import com.example.kalansage.model.FileInfo;
import com.example.kalansage.model.Role;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.FileInfoRepository;
import com.example.kalansage.repository.RoleRepository;
import com.example.kalansage.repository.UserRepository;
import com.example.kalansage.service.AbonnementService;
import com.example.kalansage.service.FilesStorageServiceImpl;
import com.example.kalansage.service.UserService;
import com.example.kalansage.service.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private UserService userService;
    @Autowired
    private UserServiceImpl userServiceImpl;
    @Autowired
    private AbonnementService abonnementService;
    @Autowired
    private FilesStorageServiceImpl filesStorageService;
    @Autowired
    private FileInfoRepository fileInfoRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping(path = "/creer-user", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> creerUser(
            @RequestParam("nom") String nom,
            @RequestParam("prenom") String prenom,
            @RequestParam("email") String email,
            @RequestParam("telephone") String telephone,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("status") Boolean status,
            @RequestParam(value = "file", required = false) MultipartFile file) throws IOException {

        // Set the default role to "USER"
        String nomRole = "USER";
        Optional<Role> userRole = roleRepository.findRoleByNomRole(nomRole);
        if (userRole.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Collections.singletonMap("message", "Le rôle 'USER' n'existe pas. Veuillez contacter un administrateur."));
        }

        Optional<User> existingUser = userRepository.findByEmail(email);
        if (existingUser.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Collections.singletonMap("message", "Un utilisateur avec cet email existe déjà."));
        }

        FileInfo fileInfo = null;
        if (file != null && !file.isEmpty()) {
            // Validate the image type (only allow PNG or JPEG)
            String fileExtension = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
            if (!fileExtension.equalsIgnoreCase("png") && !fileExtension.equalsIgnoreCase("jpg") && !fileExtension.equalsIgnoreCase("jpeg")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Collections.singletonMap("message", "Oups! l'image doit être au format PNG, JPEG ou JPG."));
            }

            // Rename the file according to a specific format (e.g., nom_1.png)
            String renamedFile = nom.replace(" ", "_") + "1." + fileExtension;

            // Save the file to a specific folder
            String specificFolderPath = "/profile";  // Adjust path as needed
            fileInfo = filesStorageService.saveFileInSpecificFolderWithCustomName(file, specificFolderPath, renamedFile);

            // Save the FileInfo object before associating it with the User
            fileInfo = fileInfoRepository.save(fileInfo);
        }

        // Create a new user
        User user = new User();
        user.setNom(nom);
        user.setPrenom(prenom);
        user.setUsername(username);
        user.setEmail(email);
        user.setTelephone(telephone);
        user.setMotDePasse(passwordEncoder.encode(password));
        user.setDateInscription(new Date());
        user.setStatus(status);
        user.setRole(userRole.get());
        user.setFileInfos(fileInfo); // Set the saved fileInfo object

        // Save the user
        userRepository.save(user);
        return ResponseEntity.ok(Collections.singletonMap("message", "Utilisateur créé avec succès!"));
    }

    private String getExtension(String filename) {
        return filename.substring(filename.lastIndexOf('.') + 1);
    }

    @PutMapping(path = "/modifier-user/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> updateUser(
            @PathVariable Long id,
            @RequestParam(value = "nom", required = false) String nom,
            @RequestParam(value = "prenom", required = false) String prenom,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "telephone", required = false) String telephone,
            @RequestParam(value = "username", required = false) String username,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "role", required = false) String nomRole,
            @RequestParam(value = "status", required = false) Boolean status,
            @RequestParam(value = "file", required = false) MultipartFile file) throws IOException {

        // Vérifier si l'utilisateur existe
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Cet utilisateur n'existe plus.");
        }
        User user = userOptional.get();
        // Récupérer le rôle de l'utilisateur actuellement connecté
        User currentUser = getCurrentLoggedInUser();
        if (currentUser == null || currentUser.getRole() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Utilisateur non autorisé.");
        }
        // Vérifier l'autorisation pour la modification du rôle
        if (!isValidRoleUpdate(currentUser, user, nomRole)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("Impossible de donner le rôle 'ADMIN' à "
                            + user.getNom() + " " + user.getPrenom() + ". " +
                            "Vous êtes " + currentUser.getRole().getNomRole() + ".");
        }

        // Mise à jour des champs de l'utilisateur
        champModifier(user, nom, prenom, email, telephone, username, password, status, file);
        userRepository.save(user);
        return ResponseEntity.ok(user);
    }

    // Méthode pour vérifier si la mise à jour du rôle est valide
    private boolean isValidRoleUpdate(User currentUser, User user, String nomRole) {
        if (nomRole == null || "USER".equalsIgnoreCase(nomRole)) {
            return true; // Autoriser l'attribution du rôle "USER"
        }

        // Récupérer le rôle dans la base de données
        Optional<Role> newRole = roleRepository.findRoleByNomRole(nomRole);
        if (newRole.isEmpty()) {
            return false;
        }

        // Seul un utilisateur "ADMIN" peut assigner le rôle "ADMIN"
        if ("ADMIN".equalsIgnoreCase(newRole.get().getNomRole())) {
            return "ADMIN".equalsIgnoreCase(currentUser.getRole().getNomRole());
        }

        return true;
    }

    private void champModifier(User user, String nom, String prenom, String email,String telephone, String username, String password, Boolean status, MultipartFile file) throws IOException {
        if (nom != null && !nom.isEmpty()) {
            user.setNom(nom);
        }
        if (prenom != null && !prenom.isEmpty()) {
            user.setPrenom(prenom);
        }
        if (username != null && !username.isEmpty()) {
            user.setUsername(username);
        }
        if (email != null && !email.isEmpty()) {
            user.setEmail(email);
        }
        if (telephone != null && !telephone.isEmpty()) {
            user.setTelephone(telephone);
        }
        if (password != null && !password.isEmpty()) {
            user.setMotDePasse(passwordEncoder.encode(password));
        }
        if (status != null) {
            user.setStatus(status);
        }
        if (file != null && !file.isEmpty()) {
            FileInfo fileInfo = filesStorageService.saveFile(file);
            user.setFileInfos(fileInfo);
        }
    }

    private User getCurrentLoggedInUser() {
        // Récupérer le nom d'utilisateur de l'utilisateur connecté à partir du contexte de sécurité
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        // Rechercher l'utilisateur dans la base de données par nom d'utilisateur
        Optional<User> currentUser = userRepository.findByUsername(username);
        return currentUser.orElse(null); // Retourner l'utilisateur ou null s'il n'est pas trouvé
    }


    @DeleteMapping("/delete-user/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Utilisateur no vie necore.");
        }
        User userToDelete = userOptional.get();
        String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
        String currentUserRole = SecurityContextHolder.getContext().getAuthentication().getAuthorities().iterator().next().getAuthority();
        if (!userToDelete.getUsername().equals(currentUsername)) {
            if (!"ADMIN".equalsIgnoreCase(currentUserRole)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Vous n'êtes pas autorisé à supprimer d'autres utilisateurs.");
            }
            if ("adminRole".equalsIgnoreCase(userToDelete.getRole().getNomRole()) && !"ADMIN".equalsIgnoreCase(currentUserRole)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Vous n'avez pas l'autorisation de supprimer un utilisateur 'ADMIN'.");
            }
        }
        userRepository.delete(userToDelete);
        return ResponseEntity.ok("User deleted successfully.");
    }


    // --------------cherche un utilisateur par id---------------------------------------------
    @GetMapping("/par-id/{id}")
    public ResponseEntity<Optional<User>> getUser(@PathVariable Long id) {
        try {
            Optional<User> user = userRepository.findById(id);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    //-----------------------------------cherche un utilisateur par username---------------------------------------------
    @GetMapping("/par/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        return new ResponseEntity<>(userService.trouverParUsername(username), HttpStatus.OK);
    }


    //-----------------------------------list des utilisateurs par role---------------------------------------------
    @GetMapping("/role/{nomRole}")
    public ResponseEntity<List<User>> getUsersByRole(@PathVariable String nomRole) {
        Optional<Role> role = roleRepository.findRoleByNomRole(nomRole);
        if (role.isPresent()) {
            List<User> user = userRepository.findByRole(role.get());
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    //-----------------------------------trouver un utilisateur par email---------------------------------------------
    @GetMapping("/email/{email}")
    public ResponseEntity<String> getUserByEmail(@PathVariable String email) {
        Optional<User> user = userRepository.findByEmail(email);
        return user.map(value -> ResponseEntity.ok(value.toString())).orElseGet(()
                -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Utilisateur avec " + email + "  porté disparu !."));
    }

    //-----------------------------------liste des utilisateurs---------------------------------------------
    @GetMapping("/list-users")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.listerUsers();
        return ResponseEntity.ok(users);
    }

    // ---------------------------------------------------
    @PostMapping("/reset-password-request")
    public ResponseEntity<?> resetPasswordRequest(@RequestBody PasswordResetRequest request) {
        String email = request.getEmail(); // Extract email from the request body
        String token = userServiceImpl.generateResetToken(email);
        if (token != null) {
            userServiceImpl.sendPasswordResetEmail(email, token);
            return ResponseEntity.ok(Collections.singletonMap("message", "Vous avez reçu un courriel sur "+email+" envoyé pour la réinitialisation du mot de passe."));
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(Collections.singletonMap("message", "Aucun utilisateur " + email + " n'a été trouvé avec cet email."));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody PasswordResetRequest request) {
        // Find the user by their email
        Optional<User> userOptional = userRepository.findByEmail(request.getEmail());
        if (userOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Utilisateur non trouvé.");
        }

        User user = userOptional.get();

        // Set the new password provided by the user
        String newPassword = request.getNewPassword();
        user.setMotDePasse(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        sendPasswordResetEmail(user.getEmail());

        return ResponseEntity.ok("Le mot de passe a été réinitialisé avec succès pour " + user.getEmail() + ".");
    }


    private void sendPasswordResetEmail(String toEmail) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Réinitialisation de mot de passe");
        message.setText("Votre mot de passe à été reinitialiser ! ");
        mailSender.send(message);
    }


}