package com.example.kalansage.service;

import com.example.kalansage.model.Evaluation;

import java.util.List;
import java.util.Optional;

public interface EvaluationService {
    Evaluation creerEvaluation(Evaluation evaluation);

    Evaluation modifierEvaluation(Evaluation evaluation);

    void supprimerEvaluation(Long idEvaluation);

    Optional<Evaluation> getEvaluation(Long idEvaluation);

    List<Evaluation> listerEvaluations();

    Object creerEvaluation(Long userId, Long courseId, String comment, int rating);
}