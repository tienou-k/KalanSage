package com.example.kalansage.repository;

import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserLecon;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface UserLeconRepository extends JpaRepository<UserLecon, Long> {
    List<UserLecon> findByUser(User user);

}