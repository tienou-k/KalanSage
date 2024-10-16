package com.example.kalansage.repository;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserModuleRepository extends JpaRepository<UserModule, Long> {
    List<UserModule> findByUser(User user);

    //boolean existsByUserAndModules(User user, Module module);
    boolean existsByUserAndModule(User user, Module module);
    long countByModule(Module  module);
}
