package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.userAction.Quiz;
import com.example.kalansage.repository.QuizRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QuizService {
    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private LeconsService leconsService;

    public Quiz addQuiz(Long moduleId, String questions) {
        Lecons lecons = (Lecons) leconsService.getLeconById(moduleId).orElseThrow(() -> new RuntimeException("Module not found"));

        Quiz quiz = new Quiz();
        quiz.setLecons(lecons);
        quiz.setQuestions(questions);

        return quizRepository.save(quiz);
    }
}
