package com.example.kalansage.repository;

import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {
    List<UserProgress> findByUser(User user);

    Optional<UserProgress> findByUser_Id(Long userId);

}
