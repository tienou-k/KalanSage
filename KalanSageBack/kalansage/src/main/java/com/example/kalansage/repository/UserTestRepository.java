package com.example.kalansage.repository;

import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserTest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserTestRepository extends JpaRepository<UserTest, Long> {
    List<UserTest> findByUser(User user);
}
