package com.example.kalansage.service;

import com.example.kalansage.model.Evaluation;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.EvaluationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class EvaluationServiceImpl implements EvaluationService {

    @Autowired
    private EvaluationRepository evaluationRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private ModuleServiceImpl modulesService;

    public Evaluation creerEvaluation(Long userId, Long moduleId, String comment, int rating) {
        User user = userService.getUserById(userId);
        Module modules = modulesService.getModuleModel(moduleId);
        if (modules == null) {
            throw new RuntimeException("Course not retrouvéeee");
        }
        if (!userService.hasComplete(user, modules)) {
            throw new RuntimeException("L'utilisateur n'a pas achevé ce cours.");
        }
        Evaluation evaluation = new Evaluation();
        Set<User> userSet = new HashSet<>();
        userSet.add(user);
        evaluation.setUsers(userSet);

        evaluation.setModule(modules);
        evaluation.setCommentaire(comment);
        evaluation.setEtoiles(rating);
        return evaluationRepository.save(evaluation);
    }


    @Override
    public Evaluation creerEvaluation(Evaluation evaluation) {
        return evaluationRepository.save(evaluation);
    }

    @Override
    public Evaluation modifierEvaluation(Evaluation evaluation) {
        Optional<Evaluation> existingEvaluation = evaluationRepository.findById(evaluation.getIdEvaluation());
        if (existingEvaluation.isPresent()) {
            Evaluation updatedEvaluation = existingEvaluation.get();
            updatedEvaluation.setEtoiles(evaluation.getEtoiles());
            updatedEvaluation.setCommentaire(evaluation.getCommentaire());
            updatedEvaluation.setModule(evaluation.getModule());
            return evaluationRepository.save(updatedEvaluation);
        } else {
            throw new IllegalArgumentException("Évaluation introuvable avec l'ID : " + evaluation.getIdEvaluation());
        }
    }

    @Override
    public void supprimerEvaluation(Long idEvaluation) {
        Optional<Evaluation> evaluationOptional = evaluationRepository.findById(idEvaluation);
        if (evaluationOptional.isPresent()) {
            evaluationRepository.delete(evaluationOptional.get());
        } else {
            throw new IllegalArgumentException("Évaluation introuvable avec l'ID : " + idEvaluation);
        }
    }

    @Override
    public Optional<Evaluation> getEvaluation(Long idEvaluation) {
        return evaluationRepository.findById(idEvaluation);
    }

    @Override
    public List<Evaluation> listerEvaluations() {
        return evaluationRepository.findAll();
    }
}

