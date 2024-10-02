package com.example.kalansage.controller;

import com.example.kalansage.model.JwtResponse;
import com.example.kalansage.model.LoginRequest;
import com.example.kalansage.service.CustomUserDetailsService;
import com.example.kalansage.service.UtilisateurService;
import com.example.kalansage.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody LoginRequest authRequest) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getMotDePasse())
            );
            final UserDetails userDetails = customUserDetailsService.loadUserByUsername(authRequest.getUsername());
            final String jwt = jwtUtil.generateToken(userDetails);
            return ResponseEntity.ok().body(new JwtResponse(jwt, "Login successful! Welcome to " + userDetails.getUsername() + "!"));
        } catch (AuthenticationException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Mot de passe ou Username incorrect");
        } catch (Exception e) {

            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de l'authentification! .");
        }
    }

    //------------------------utilisateru se deconnecter----------------------------------------
    @PostMapping("/se-deconnecter")
    public ResponseEntity<String> seDeconnecter() {
        try {
            utilisateurService.seDeconnecter();
            return ResponseEntity.ok("Deconnexion 🥺 ! Triste de voir parti si tot");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Please try again.");
        }
    }

}

