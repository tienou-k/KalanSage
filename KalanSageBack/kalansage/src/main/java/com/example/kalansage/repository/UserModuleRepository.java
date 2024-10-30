package com.example.kalansage.repository;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserModuleRepository extends JpaRepository<UserModule, Long> {
    boolean existsByUserAndModule(User user, Module module);
    long countByModule(Module  module);
    List<UserModule> findByUserId(long userId);
    Optional<UserModule> findByUserIdAndModuleId(Long userId, Long moduleId);
    boolean existsByUserIdAndModuleId(Long userId, Long moduleId);
    @Query("SELECT um.module FROM UserModule um GROUP BY um.module ORDER BY COUNT(um.user) DESC")
    List<Module> findTop10ByOrderByUserIdDesc();
}
