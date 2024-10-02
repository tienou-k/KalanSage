package com.example.kalansage.repository;

import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserQuiz;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserQuizRepository extends JpaRepository<UserQuiz, Long> {
    List<UserQuiz> findByUser(User user);
}
