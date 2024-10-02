package com.example.kalansage.controller;

import com.example.kalansage.model.userAction.Quiz;
import com.example.kalansage.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/quiz")
public class QuizController {
    @Autowired
    private QuizService quizService;

    @PostMapping("/ajouter-quiz")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Quiz> addQuiz(@RequestParam Long leconId, @RequestBody String questions) {
        return ResponseEntity.ok(quizService.addQuiz(leconId, questions));
    }
}
