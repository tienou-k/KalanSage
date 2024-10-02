package com.example.kalansage.repository;

import com.example.kalansage.model.userAction.UserPoints;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserPointsRepository extends JpaRepository<UserPoints, Long> {
}
