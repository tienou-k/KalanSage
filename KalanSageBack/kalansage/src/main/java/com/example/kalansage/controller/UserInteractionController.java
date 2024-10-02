package com.example.kalansage.controller;

import com.example.kalansage.model.Evaluation;
import com.example.kalansage.model.userAction.*;
import com.example.kalansage.service.UserInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user-interaction")
public class UserInteractionController {

    @Autowired
    private UserInteractionService userInteractionService;

    // Take a quiz
    @PostMapping("/take-quiz/{userId}/{quizId}")
    public ResponseEntity<UserQuiz> takeQuiz(
            @PathVariable Long userId,
            @PathVariable Long quizId,
            @RequestParam int score) {
        try {
            UserQuiz userQuiz = userInteractionService.passerQuiz(userId, quizId, score);
            return ResponseEntity.ok(userQuiz);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

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

    // Update user progress
    @PutMapping("/update-progress/{userId}")
    public ResponseEntity<Void> updateUserProgress(
            @PathVariable Long userId,
            @RequestParam int additionalPoints) {
        try {
            userInteractionService.mettreAJourPoints(userId, additionalPoints);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
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

    // Enroll in a course
    @PostMapping("/enroll-module/{userId}/{moduleId}")
    public ResponseEntity<UserModule> enrollInCourse(
            @PathVariable Long userId,
            @PathVariable Long moduleId) {
        try {
            UserModule userModule = userInteractionService.inscrireAuModule(userId, moduleId);
            return ResponseEntity.ok(userModule);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    // Subscribe to an abonnement
    @PostMapping("/subscribe-abonnement/{userId}/{abonnementId}")
    public ResponseEntity<UserAbonnement> subscribeToAbonnement(
            @PathVariable Long userId,
            @PathVariable Long abonnementId) {
        try {
            UserAbonnement userAbonnement = userInteractionService.sAbonner(userId, abonnementId);
            return ResponseEntity.ok(userAbonnement);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    // Earn a badge
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

    // Submit a course evaluation
    @PostMapping("/submit-evaluation/{userId}/{courseId}")
    public ResponseEntity<Evaluation> submitEvaluation(
            @PathVariable Long userId,
            @PathVariable Long courseId,
            @RequestParam String commentaire,
            @RequestParam int etoiles) {
        try {
            Evaluation evaluation = userInteractionService.soumettreEvaluation(userId, courseId, commentaire, etoiles);
            return ResponseEntity.ok(evaluation);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
}
