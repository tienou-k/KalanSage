package com.example.kalansage.repository;

import com.example.kalansage.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    // trouver un role par son nom
    Optional<Role> findRoleByNomRole(String nomRole);
}
