package com.example.kalansage.controller;



import com.example.kalansage.model.Module;
import com.example.kalansage.model.Review;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBadge;
import com.example.kalansage.model.userAction.UserLecon;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.model.userAction.UserTest;
import com.example.kalansage.service.UserInteractionService;
import com.example.kalansage.service.UserPointsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserInteractionController {

    @Autowired
    private UserInteractionService userInteractionService;

    @Autowired
    private UserPointsService userPointsService;
    // Take a quiz


    // Take a test
    @PostMapping("/take-test/{userId}/{testId}")
    public ResponseEntity<UserTest> takeTest(
            @PathVariable Long userId,
            @PathVariable Long testId,
            @RequestParam int score) {
        try {
            UserTest userTest = userInteractionService.passerTest(userId, testId, score);
            return ResponseEntity.ok(userTest);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }


    // Complete a lesson
    @PostMapping("/complete-lesson/{userId}/{lessonId}")
    public ResponseEntity<UserLecon> completeLesson(
            @PathVariable Long userId,
            @PathVariable Long lessonId,
            @RequestParam int pointsEarned) {
        try {
            UserLecon userLecon = userInteractionService.completerLecon(userId, lessonId, pointsEarned);
            return ResponseEntity.ok(userLecon);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    // Complete a module
    @PostMapping("/complete-module/{userId}/{moduleId}")
    public ResponseEntity<UserModule> completeModule(
            @PathVariable Long userId,
            @PathVariable Long moduleId,
            @RequestParam int pointsEarned) {
        try {
            UserModule userModule = userInteractionService.completerModule(userId, moduleId, pointsEarned);
            return ResponseEntity.ok(userModule);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
    @PostMapping("/gagner/points")
    public ResponseEntity<String> awardPoints(@RequestParam Long userId, @RequestParam int points) {
        userPointsService.awardPoints(userId, points);
        return ResponseEntity.ok("Points awarded successfully.");
    }
    // Enroll in a course
    @PostMapping("/inscrisModule/{userId}/{moduleId}")
    public ResponseEntity<Map<String, Object>> enrollInCourse(
            @PathVariable Long userId,
            @PathVariable Long moduleId) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Log the enrollment attempt
            log.info("Attempting to enroll user {} in module {}", userId, moduleId);

            // Check if the user is already enrolled in the module
            boolean isAlreadyEnrolled = userInteractionService.isUserAlreadyEnrolled(userId, moduleId);
            if (isAlreadyEnrolled) {
                log.warn("User {} is already enrolled in module {}", userId, moduleId);
                response.put("success", false);
                response.put("message", "Vous êtes déjà inscrit à ce module.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            // Enroll the user in the module if not already enrolled
            UserModule userModule = userInteractionService.inscrireAuModule(userId, moduleId);
            response.put("success", true);
            response.put("message", "Inscription réussie au module.");
            log.info("User {} successfully enrolled in module {}", userId, moduleId);

            return ResponseEntity.ok(response);

        } catch (DataIntegrityViolationException e) {
            log.error("Data integrity violation while enrolling user {} in module {}: {}", userId, moduleId, e.getMessage());
            response.put("success", false);
            response.put("message", "Une erreur de base de données est survenue.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);

        } catch (Exception e) {
            log.error("Error enrolling user {} in module {}: {}", userId, moduleId, e.getMessage());
            response.put("success", false);
            response.put("message", "Une erreur est survenue lors du traitement de votre demande.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // Endpoint to get all modules a user is enrolled in
    @GetMapping("/{userId}/modules")
    public ResponseEntity<List<Module>> getModulesForUser(@PathVariable int userId) {
        List<Module> userModules = userInteractionService.getModulesForUser(userId);
        if (userModules.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(userModules);
    }

    @PostMapping("/modules/{moduleId}/progress")
    public ResponseEntity<?> updateModuleProgress(@PathVariable Long moduleId,
                                                  @RequestParam Long userId,
                                                  @RequestParam int progress) {
        try {
            userInteractionService.updateProgress(userId, moduleId, progress);
            return ResponseEntity.ok(Collections.singletonMap("message", "Module progress updated."));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("message", e.getMessage()));
        }
    }
    @GetMapping("/{moduleId}/progress")
    public ResponseEntity<?> getModuleProgress(@PathVariable Long moduleId, @RequestParam Long userId) {
        try {
            UserModule userModule = userInteractionService.getUserModule(userId, moduleId);
            return ResponseEntity.ok(userModule);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("message", e.getMessage()));
        }
    }
    @PostMapping("/earn-badge/{userId}/{badgeId}")
    public ResponseEntity<UserBadge> earnBadge(
            @PathVariable Long userId,
            @PathVariable Long badgeId) {
        try {
            UserBadge userBadge = userInteractionService.obtenirBadge(userId, badgeId);
            return ResponseEntity.ok(userBadge);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }


    @PostMapping("/submit-review/{userId}/{courseId}")
    public ResponseEntity<Review> submitReview(
            @PathVariable Long userId,
            @PathVariable Long courseId,
            @RequestParam String commentaire,
            @RequestParam int etoiles) {
        try {
            Review review = userInteractionService.soumettreReview(userId, courseId, commentaire, etoiles);
            return ResponseEntity.ok(review);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }


    @PostMapping("/abonnement/{userId}/{abonnementId}")
    @PreAuthorize("hasRole('ROLE_USER')")
    public ResponseEntity<?> enrollUserInAbonnement(@PathVariable Long userId, @PathVariable Long abonnementId) {
        try {
            userInteractionService.sAbonner(userId, abonnementId);
            return ResponseEntity.ok("Courage 💪 vous avez desormais l'abonnement " + abonnementId + "!");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @GetMapping("/users/{abonnementId}")
    public ResponseEntity<List<User>> getUsersByAbonnement(@PathVariable Long abonnementId) {
        List<User> users = userInteractionService.getUsersByAbonnement(abonnementId);
        if (users.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(users);
    }

}
