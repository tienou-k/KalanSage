package com.example.kalansage.controller;


import com.example.kalansage.model.Quiz;
import com.example.kalansage.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/quizzes")
public class QuizController {

    @Autowired
    private QuizService quizService;

    @PostMapping("/creer-quiz")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Quiz> creerQuiz(@RequestBody Quiz quiz) {
        Quiz newQuiz = quizService.creerQuiz(quiz);
        return ResponseEntity.ok(newQuiz);
    }

    @GetMapping("/lecon/{leconId}")
    public ResponseEntity<Optional<Quiz>> getQuizByLeconId(@PathVariable Long leconId) {
        Optional<Quiz> quiz = quizService.getQuizByLeconId(leconId);
        return ResponseEntity.ok(quiz);
    }

    @DeleteMapping("/supprimer-quiz/{quizId}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> supprimerQuiz(@PathVariable Long quizId) {
        quizService.supprimerQuiz(quizId);
        return ResponseEntity.noContent().build();
    }
    // quiz list

}
