package com.example.kalansage.service;

import com.example.kalansage.model.Quiz;
import com.example.kalansage.repository.QuizRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class QuizService {

    @Autowired
    private QuizRepository quizRepository;

    public Quiz creerQuiz(Quiz quiz) {
        return quizRepository.save(quiz);
    }

    public Optional<Quiz> getQuizByLeconId(Long leconId) {
        return Optional.ofNullable(quizRepository.findByLecon_IdLecon(leconId));
    }

    public void supprimerQuiz(Long quizId) {
        quizRepository.deleteById(quizId);
    }
}
