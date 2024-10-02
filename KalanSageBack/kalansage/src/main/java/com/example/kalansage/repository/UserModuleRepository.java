package com.example.kalansage.repository;

import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserModuleRepository extends JpaRepository<UserModule, Long> {
    List<UserModule> findByUser(User user);

    boolean existsByUserAndModules(User user, Module module);
}
