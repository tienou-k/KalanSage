package com.example.kalansage.repository;

import com.example.kalansage.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    Optional<Review> findById(Long idCours);

    Optional<Review> findReviewByIdReview(Long idReview);
}
