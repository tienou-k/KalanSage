package com.example.kalansage.service;

import com.example.kalansage.model.Review;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private ModuleServiceImpl modulesService;

    public Review creerReview(Long id, Long moduleId, String comment, int rating) {
        User user = userService.getUser(id);
        Module modules = modulesService.getModuleModel(moduleId);
        if (modules == null) {
            throw new RuntimeException("Course not retrouvéeee");
        }
        if (!userService.hasComplete(user, modules)) {
            throw new RuntimeException("L'utilisateur n'a pas achevé ce cours.");
        }
        Review review = new Review();
        Set<User> userSet = new HashSet<>();
        userSet.add(user);
        review.setUsers(userSet);

        review.setModule(modules);
        review.setCommentaire(comment);
        review.setEtoiles(rating);
        return reviewRepository.save(review);
    }


    @Override
    public Review creerReview(Review review) {
        return reviewRepository.save(review);
    }

    @Override
    public Review modifierReview(Review review) {
        Optional<Review> existingReview = reviewRepository.findById(review.getIdReview());
        if (existingReview.isPresent()) {
            Review updatedReview = existingReview.get();
            updatedReview.setEtoiles(review.getEtoiles());
            updatedReview.setCommentaire(review.getCommentaire());
            updatedReview.setModule(review.getModule());
            return reviewRepository.save(updatedReview);
        } else {
            throw new IllegalArgumentException("Review introuvable avec l'ID : " + review.getIdReview());
        }
    }

    @Override
    public void supprimerReview(Long idReview) {
        Optional<Review> reviewOptional = reviewRepository.findById(idReview);
        if (reviewOptional.isPresent()) {
            reviewRepository.delete(reviewOptional.get());
        } else {
            throw new IllegalArgumentException("Rieview introuvable avec l'ID : " + idReview);
        }
    }

    @Override
    public Optional<Review> getReview(Long idReview) {
        return reviewRepository.findById(idReview);
    }

    @Override
    public List<Review> listerReviews() {
        return reviewRepository.findAll();
    }
}

