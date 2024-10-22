package com.example.kalansage.controller;



import com.example.kalansage.model.Review;
import com.example.kalansage.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/Reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping("/creer-review")

    public ResponseEntity<Review> addReview(@RequestParam Long userId, @RequestParam Long courseId, @RequestBody String comment, @RequestParam int rating) {
        return ResponseEntity.ok((Review) reviewService.creerReview(userId, courseId, comment, rating));
    }

    @PutMapping("/modifier-review/{id}")
    public ResponseEntity<Review> modifierReview(@PathVariable Long id, @RequestBody Review review) {
        review.setIdReview(id);
        // fields to be updated
        if (review.getEtoiles() != 0) {
            review.setEtoiles(review.getEtoiles());
        }
        if (review.getCommentaire() != null) {
            review.setCommentaire(review.getCommentaire());
        }
        return ResponseEntity.ok(reviewService.modifierReview(review));
    }

    @DeleteMapping("/supprimer-review/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> supprimerReview(@PathVariable Long id) {
        try {
            reviewService.supprimerReview(id);
            return ResponseEntity.ok("Review supprimer avce suucès");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de la suppression du cours");
        }
    }

    @GetMapping("/review-par/{id}")
    public ResponseEntity<Optional<Review>> getReview(@PathVariable Long id) {
        return ResponseEntity.ok(reviewService.getReview(id));
    }

    @GetMapping("/list-reviews")
    public ResponseEntity<List<Review>> listerReviews() {
        return ResponseEntity.ok(reviewService.listerReviews());
    }
}
