package com.example.kalansage.controller;




import com.example.kalansage.dto.JwtResponse;
import com.example.kalansage.model.LoginRequest;
import com.example.kalansage.model.Utilisateur;
import com.example.kalansage.repository.UtilisateurRepository;
import com.example.kalansage.service.CustomUserDetailsService;
import com.example.kalansage.service.OTPService;
import com.example.kalansage.service.UtilisateurService;
import com.example.kalansage.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
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
    @Autowired
    private OTPService otpService;

    // Login endpoint: returns both access token and refresh token
    @PostMapping("/login")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody LoginRequest authRequest) {
        try {
            // Check if the user exists
            Utilisateur user = utilisateurService.findByEmail(authRequest.getEmail());
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                        Map.of("message", "Utilisateur non trouvé")
                );
            }
            // Attempt to authenticate
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getEmail(), authRequest.getMotDePasse())
            );
            // If authentication is successful, load user details
            final UserDetails userDetails = customUserDetailsService.loadUserByUsername(authRequest.getEmail());
            // Extract the role from the user details
            String role = userDetails.getAuthorities().iterator().next().getAuthority();
            // Generate the JWT access token and refresh token
            final String accessToken = jwtUtil.generateToken(userDetails, role);
            final String refreshToken = jwtUtil.generateRefreshToken(userDetails);
            // Create JWT response including userId
            JwtResponse jwtResponse = new JwtResponse(accessToken, role, refreshToken, user.getId());
            return ResponseEntity.ok().body(jwtResponse);
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                    Map.of("message", "Mot de passe incorrect")
            );
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                    Map.of("message", "Erreur d'authentification")
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                    Map.of("message", "Erreur lors de l'authentification!")
            );
        }
    }
  /*  @PostMapping("/login")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody LoginRequest authRequest) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getEmail(), authRequest.getMotDePasse())
            );
            final UserDetails userDetails = customUserDetailsService.loadUserByUsername(authRequest.getEmail());
            // Extract the role from the user details
            String role = userDetails.getAuthorities().iterator().next().getAuthority();
            // Fetch the user to get userId
            Utilisateur user = utilisateurService.findByEmail(authRequest.getEmail());
            // Generate the JWT access token and refresh token
            final String accessToken = jwtUtil.generateToken(userDetails, role);
            final String refreshToken = jwtUtil.generateRefreshToken(userDetails);
            // Create JWT response including userId
            JwtResponse jwtResponse = new JwtResponse(accessToken, role, refreshToken, user.getId()); // Assuming getId() returns userId
            return ResponseEntity.ok().body(jwtResponse);
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Mot de passe ou email incorrect");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de l'authentification!");
        }
    }*/

    // Refresh token endpoint: generates a new access token using a valid refresh token
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshAccessToken(@RequestBody Map<String, String> request) {
        String refreshToken = request.get("refreshToken");
        if (refreshToken == null || refreshToken.isEmpty()) {
            return ResponseEntity.badRequest().body("Refresh token is missing");
        }
        try {
            // Validate the refresh token
            if (jwtUtil.validateRefreshToken(refreshToken)) {
                // Extract username from refresh token
                String username = jwtUtil.extractUsername(refreshToken);
                UserDetails userDetails = customUserDetailsService.loadUserByUsername(username);
                // Generate a new access token
                String newAccessToken = jwtUtil.generateToken(
                        userDetails,
                        userDetails.getAuthorities().iterator().next().getAuthority());
                // Return the new access token
                Map<String, String> response = new HashMap<>();
                response.put("accessToken", newAccessToken);
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired refresh token");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Could not refresh access token");
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

    // Endpoint to request OTP
    @PostMapping("/generate-otp")
    public ResponseEntity<String> generateOTP(@RequestParam String email, @RequestParam String deviceToken) {
        otpService.createAndSendOTP(email, deviceToken);
        return ResponseEntity.ok("OTP sent via push notification.");
    }

    // Endpoint to verify OTP
    @PostMapping("/verify-otp")
    public ResponseEntity<String> verifyOTP(@RequestParam String email, @RequestParam String otp) {
        boolean isVerified = otpService.verifyOTP(email, otp);
        if (isVerified) {
            return ResponseEntity.ok("OTP verified successfully!");
        } else {
            return ResponseEntity.status(401).body("Invalid or expired OTP.");
        }
    }
}
