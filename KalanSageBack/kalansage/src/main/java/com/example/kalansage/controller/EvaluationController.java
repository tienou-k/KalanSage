package com.example.kalansage.controller;


import com.example.kalansage.model.Evaluation;
import com.example.kalansage.service.EvaluationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/evaluations")
public class EvaluationController {

    @Autowired
    private EvaluationService evaluationService;

    @PostMapping("/creer-evaluation")
    public ResponseEntity<Evaluation> addEvaluation(@RequestParam Long userId, @RequestParam Long courseId, @RequestBody String comment, @RequestParam int rating) {
        return ResponseEntity.ok((Evaluation) evaluationService.creerEvaluation(userId, courseId, comment, rating));
    }

    @PutMapping("/modifier-evaluation/{id}")
    public ResponseEntity<Evaluation> modifierEvaluation(@PathVariable Long id, @RequestBody Evaluation evaluation) {
        evaluation.setIdEvaluation(id);
        // fields to be updated
        if (evaluation.getEtoiles() != 0) {
            evaluation.setEtoiles(evaluation.getEtoiles());
        }
        if (evaluation.getCommentaire() != null) {
            evaluation.setCommentaire(evaluation.getCommentaire());
        }
        return ResponseEntity.ok(evaluationService.modifierEvaluation(evaluation));
    }

    @DeleteMapping("/supprimer-evaluation/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> supprimerEvaluation(@PathVariable Long id) {
        try {
            evaluationService.supprimerEvaluation(id);
            return ResponseEntity.ok("Evaluation supprimer avce suucès");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur lors de la suppression du cours");
        }
    }

    @GetMapping("/evaluation-par/{id}")
    public ResponseEntity<Optional<Evaluation>> getEvaluation(@PathVariable Long id) {
        return ResponseEntity.ok(evaluationService.getEvaluation(id));
    }

    @GetMapping("/list-evaluations")
    public ResponseEntity<List<Evaluation>> listerEvaluations() {
        return ResponseEntity.ok(evaluationService.listerEvaluations());
    }
}
