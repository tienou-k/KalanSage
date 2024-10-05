package com.example.kalansage.controller;

import com.example.kalansage.model.JwtResponse;
import com.example.kalansage.model.LoginRequest;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.UtilisateurRepository;
import com.example.kalansage.service.CustomUserDetailsService;
import com.example.kalansage.service.UtilisateurService;
import com.example.kalansage.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "")
public class AuthenticationController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private UtilisateurService utilisateurService;
    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody LoginRequest authRequest) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getEmail(), authRequest.getMotDePasse())
            );
            final UserDetails userDetails = customUserDetailsService.loadUserByUsername(authRequest.getEmail());
            // Extract the role from the user details
            String role = userDetails.getAuthorities().iterator().next().getAuthority();
            // Generate the JWT token including the role
            final String jwt = jwtUtil.generateToken(userDetails, role);
            return ResponseEntity.ok().body(new JwtResponse(jwt, role));
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Mot de passe ou email incorrect");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de l'authentification!");
        }
    }


    @GetMapping("/profil")
    public ResponseEntity<?> getProfile() {
        // Get the currently authenticated user
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserEmail = authentication.getName();
        // Fetch the user from the service using email
        Utilisateur user = utilisateurService.findByEmail(currentUserEmail);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.badRequest().body("User not found");
        }
    }

    @PostMapping("/se-deconnecter")
    public ResponseEntity<Map<String, String>> seDeconnecter(@RequestHeader("Authorization") String token) {
        Map<String, String> response = new HashMap<>();
        try {
            String jwtToken = token.replace("Bearer ", "");
            utilisateurService.seDeconnecter(jwtToken);
            response.put("message", "Déconnexion 🥺 ! Triste de vous voir partir si tôt.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("message", "Une erreur s'est produite. Veuillez réessayer.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

}
