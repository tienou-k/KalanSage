package com.example.kalansage.repository;

import com.example.kalansage.model.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EvaluationRepository extends JpaRepository<Evaluation, Long> {

    Optional<Evaluation> findById(Long idCours);

    Optional<Evaluation> findEvaluationByIdEvaluation(Long idEvalution);
}
