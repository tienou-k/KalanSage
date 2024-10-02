package com.example.kalansage.service;

import com.example.kalansage.model.Role;

import java.util.List;
import java.util.Optional;

public interface RoleService {

    Role creerRole(Role role);

    Role modifierRole(Role role);

    void supprimerRole(Long id);

    Optional<Role> getRole(Long id);

    List<Role> listerRoles();

    Optional<Role> getRoleByNomRole(String nomRole);
}

