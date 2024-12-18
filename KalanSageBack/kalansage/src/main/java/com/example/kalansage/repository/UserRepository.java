package com.example.kalansage.repository;


import com.example.kalansage.model.Module;
import com.example.kalansage.model.Role;
import com.example.kalansage.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmailOrUsername(String email, String username);
    List<User> findByRole(Role role);
    @Query("SELECT u FROM User u JOIN u.abonnementUser a")
    List<User> findAllAbonnementUsers();
    User findUserById(Long id);
    Optional<User> findByResetToken(String resetToken);
}