package com.example.kalansage.config;


import com.example.kalansage.model.*;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.*;
import com.example.kalansage.service.FilesStorageServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Arrays;
import java.util.Date;
import java.util.Optional;

@Component
public class DataInitializer {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private CategorieRepository categorieRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FilesStorageServiceImpl filesStorageService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostConstruct
    public void initData() {
        initializeRoles();
        initializeCategories();
        initializeAbonnements();
        initializeAdmin();
        System.out.println("Données initialisées avec succès.");
    }

    private void initializeRoles() {
        if (roleRepository.findAll().isEmpty()) {
            Role adminRole = new Role();
            adminRole.setNomRole("ADMIN");

            Role userRole = new Role();
            userRole.setNomRole("USER");

            roleRepository.saveAll(Arrays.asList(adminRole, userRole));
            System.out.println("Rôles initialisés: ADMIN, USER");
        }
    }

    private void initializeCategories() {
        if (categorieRepository.findAll().isEmpty()) {
            Categorie cat1 = new Categorie();
            cat1.setNomCategorie("Programming");
            cat1.setDescription("Module liés aux langages et frameworks de programmation.");

            Categorie cat2 = new Categorie();
            cat2.setNomCategorie("Data Science");
            cat2.setDescription("Module liés à l'analyse de données, apprentissage automatique et IA.");

            Categorie cat3 = new Categorie();
            cat3.setNomCategorie("Design");
            cat3.setDescription("Module du design graphique");

            Categorie cat4 = new Categorie();
            cat4.setNomCategorie("Marketing");
            cat4.setDescription("Modules du context de marking .");

            Categorie cat5 = new Categorie();
            cat5.setNomCategorie("Communication");
            cat5.setDescription("TOus ce qui concerne la communication");

            Categorie cat6 = new Categorie();
            cat6.setNomCategorie("Finance");
            cat6.setDescription("Module  qui vous permet d'avoir un niveau expert en finance");

            Categorie cat7 = new Categorie();
            cat7.setNomCategorie("Redaction de contenu");
            cat7.setDescription("La redaction Web et ecrite pour ce module");

            Categorie cat8 = new Categorie();
            cat8.setNomCategorie("Photographie");
            cat8.setDescription("Module de la photographie en tous ");

            Categorie cat9 = new Categorie();
            cat9.setNomCategorie("Reseau");
            cat9.setDescription("Acquerir des competences en reseau et telecom");

            categorieRepository.saveAll(Arrays.asList(cat1, cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9));
            System.out.println("Catégories initialisées.");
        }
    }







    private void initializeAbonnements() {
        if (abonnementRepository.findAll().isEmpty()) {
            Abonnement abonnement1 = new Abonnement();
            abonnement1.setTypeAbonnement("Basic Plan");
            abonnement1.setStatut(true);
            abonnement1.setDescription("Accès aux cours et modules de base.");
            abonnement1.setPrix(9.99);
            abonnement1.setDateExpiration(new Date(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 30)));

            Abonnement abonnement2 = new Abonnement();
            abonnement2.setTypeAbonnement("Premium");
            abonnement2.setStatut(true);
            abonnement2.setDescription("Accès à tous les cours, modules et contenu premium.");
            abonnement2.setPrix(19.99);
            abonnement2.setDateExpiration(new Date(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 30)));

            abonnementRepository.saveAll(Arrays.asList(abonnement1, abonnement2));
            System.out.println("Abonnements d'exemple initialisés.");
        }
    }

    private void initializeAdmin() {
        if (adminRepository.findAll().isEmpty()) {
            Optional<Role> adminRole = roleRepository.findRoleByNomRole("ADMIN");
            if (adminRole.isPresent()) {
                Admin defaultAdmin = new Admin();
                defaultAdmin.setNom("Admin");
                defaultAdmin.setPrenom("ADMIN");
                defaultAdmin.setEmail("kontere13e@gmail.com");
                defaultAdmin.setUsername("admin");
                defaultAdmin.setMotDePasse(passwordEncoder.encode("admin123"));
                defaultAdmin.setDateInscription(new Date());
                defaultAdmin.setStatus(true);
                defaultAdmin.setRole(adminRole.get());


                adminRepository.save(defaultAdmin);
                System.out.println("Administrateur par défaut initialisé.");
            } else {
                System.out.println("Erreur : Le rôle 'ADMIN' n'existe pas.");
            }
        }
    }
}
