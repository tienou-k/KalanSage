package com.example.kalansage.service;


import com.example.kalansage.model.Role;
import com.example.kalansage.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleRepository roleRepository;

    public Role creerRole(Role role) {
        Optional<Role> existingRole = roleRepository.findRoleByNomRole(role.getNomRole());
        if (existingRole.isPresent()) {
            throw new IllegalStateException("Role existe déjà");
        }
        return roleRepository.save(role);
    }

    @Override
    public Role modifierRole(Role role) {
        if (roleRepository.existsById(role.getIdRole())) {
            return roleRepository.save(role);
        } else {
            throw new RuntimeException("Role not found");
        }
    }

    @Override
    public void supprimerRole(Long id) {
        roleRepository.deleteById(id);
    }

    @Override
    public Optional<Role> getRole(Long id) {
        return roleRepository.findById(id);
    }

    @Override
    public List<Role> listerRoles() {
        return roleRepository.findAll();
    }

    @Override
    public Optional<Role> getRoleByNomRole(String nomRole) {
        return roleRepository.findRoleByNomRole(nomRole);
    }


}
