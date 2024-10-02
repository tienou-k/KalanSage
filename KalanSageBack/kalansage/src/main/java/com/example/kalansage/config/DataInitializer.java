package com.example.kalansage.config;

import com.example.kalansage.model.Module;
import com.example.kalansage.model.*;
import com.example.kalansage.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
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
    private ModuleRepository ModuleRepository;

    //@Autowired private ModuleRepository moduleRepository;


    @Autowired
    private LeconsRepository leconsRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private CategorieRepository categorieRepository;

    @PostConstruct
    public void initData() {
        initializeRoles();
        initializeCategories();
        initializeModule();
        initializeLecons();
        initializeAbonnements();
        System.out.println("Data initialized successfully.");
    }

    private void initializeRoles() {
        if (roleRepository.findAll().isEmpty()) {
            Role adminRole = new Role();
            adminRole.setNomRole("ADMIN");

            Role userRole = new Role();
            userRole.setNomRole("USER");

            roleRepository.saveAll(Arrays.asList(adminRole, userRole));
            System.out.println("Initialized roles: ADMIN, USER");
        }
    }

    private void initializeCategories() {
        if (categorieRepository.findAll().isEmpty()) {
            Categorie cat1 = new Categorie();
            cat1.setNomCategorie("Programming");
            cat1.setDescription("Courses related to programming languages and frameworks.");

            Categorie cat2 = new Categorie();
            cat2.setNomCategorie("Data Science");
            cat2.setDescription("Courses related to data analysis, machine learning, and AI.");

            categorieRepository.saveAll(Arrays.asList(cat1, cat2));
            System.out.println("Initialized categories.");
        }
    }

    private void initializeModule() {
        if (ModuleRepository.findAll().isEmpty()) {

            Optional<Categorie> programmingCategory = categorieRepository.findByNomCategorie("Programming");

            if (programmingCategory.isPresent()) {
                Module module1 = new Module();
                module1.setTitre("Introduction à Spring Boot");
                module1.setDescription("Apprenez les bases de Spring Boot.");
                module1.setDateCreation(new Date());
                module1.setCategorie(programmingCategory.get());

                Module module2 = new Module();
                module2.setTitre("Programmation avancée en Java");
                module2.setDescription("Approfondir les concepts de programmation Java.");
                module2.setDateCreation(new Date());
                module2.setCategorie(programmingCategory.get());

                // Save both courses in a single operation
                ModuleRepository.saveAll(Arrays.asList(module1, module2));
                System.out.println("Initialized sample courses.");
            } else {
                System.out.println("erreur categorie Programming non rétrouvé");
            }
        }
    }


    private void initializeLecons() {
        if (leconsRepository.findAll().isEmpty()) {
            Module Module = ModuleRepository.findById(1L).orElse(null);
            if (Module != null) {
                Lecons lecons1 = new Lecons();
                lecons1.setTitre("Spring Boot Basics");
                lecons1.setDescription("Understanding the basics of Spring Boot.");
                lecons1.setModules(Module);

                Lecons lecons2 = new Lecons();
                lecons2.setTitre("Spring Boot REST APIs");
                lecons2.setDescription("Learn to create REST APIs with Spring Boot.");
                lecons2.setModules(Module);

                leconsRepository.saveAll(Arrays.asList(lecons1, lecons2));
                System.out.println("Initialized sample Module for the first course.");
            }
        }
    }


    private void initializeAbonnements() {
        if (abonnementRepository.findAll().isEmpty()) {
            Abonnement abonnement1 = new Abonnement();
            abonnement1.setTypeAbonnement("Basic Plan");
            abonnement1.setStatut(true);
            abonnement1.setDescription("Access to basic courses and Module.");
            abonnement1.setPrix(9.99);
            abonnement1.setDateExpiration(new Date(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 30))); // 30 days from now

            Abonnement abonnement2 = new Abonnement();
            abonnement2.setTypeAbonnement("Premium");
            abonnement2.setStatut(true);
            abonnement2.setDescription("Access to all courses, Module, and premium content.");
            abonnement2.setPrix(19.99);
            abonnement2.setDateExpiration(new Date(System.currentTimeMillis() + (1000 * 60 * 60 * 24 * 30))); // 30 days from now

            abonnementRepository.saveAll(Arrays.asList(abonnement1, abonnement2));
            System.out.println("Initialized sample abonnements.");
        }
    }
}