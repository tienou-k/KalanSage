package com.example.kalansage.service;

import com.example.kalansage.model.Review;

import java.util.List;
import java.util.Optional;

public interface ReviewService {
    Review creerReview(Review review);

    Review modifierReview(Review Review);

    void supprimerReview(Long idReview);

    Optional<Review> getReview(Long idReview);

    List<Review> listerReviews();

    Object creerReview(Long userId, Long courseId, String comment, int rating);
}