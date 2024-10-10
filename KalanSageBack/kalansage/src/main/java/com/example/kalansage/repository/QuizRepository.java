package com.example.kalansage.repository;


import com.example.kalansage.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {
    Quiz findByLecon_IdLecon(Long idLecon);
}
