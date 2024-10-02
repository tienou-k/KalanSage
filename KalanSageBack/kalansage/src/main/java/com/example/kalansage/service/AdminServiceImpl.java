package com.example.kalansage.service;

import com.example.kalansage.model.Admin;
import com.example.kalansage.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminRepository adminRepository;

    @Override
    public Admin creerAdmin(Admin admin) {
        return adminRepository.save(admin);
    }

    @Override
    public Admin modifierAdmin(Admin admin) {
        Optional<Admin> existingAdmin = adminRepository.findById(admin.getId());
        if (existingAdmin.isPresent()) {
            Admin updatedAdmin = existingAdmin.get();
            updatedAdmin.setNom(admin.getNom());
            updatedAdmin.setPrenom(admin.getPrenom());
            updatedAdmin.setEmail(admin.getEmail());
            updatedAdmin.setMotDePasse(admin.getMotDePasse());
            return adminRepository.save(updatedAdmin);
        } else {
            throw new IllegalArgumentException("Admin introuvable avec l'ID : " + admin.getId());
        }
    }

    @Override
    public void supprimerAdmin(Long id) {
        Optional<Admin> adminOptional = adminRepository.findById(id);
        if (adminOptional.isPresent()) {
            adminRepository.delete(adminOptional.get());
        } else {
            throw new IllegalArgumentException("Admin introuvable avec l'ID : " + id);
        }
    }

    @Override
    public Optional<Admin> getAdmin(Long id) {
        return adminRepository.findById(id);
    }

    @Override
    public List<Admin> listerAdmins() {
        return adminRepository.findAll();
    }
}