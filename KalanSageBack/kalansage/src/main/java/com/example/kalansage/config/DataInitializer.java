package com.example.kalansage.config;

import com.example.kalansage.model.Module;
import com.example.kalansage.model.*;
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
    private ModuleRepository ModuleRepository;

    @Autowired
    private LeconsRepository leconsRepository;

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
        initializeModule();
        initializeLecons();
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
            cat1.setDescription("Cours liés aux langages et frameworks de programmation.");

            Categorie cat2 = new Categorie();
            cat2.setNomCategorie("Data Science");
            cat2.setDescription("Cours liés à l'analyse de données, apprentissage automatique et IA.");

            categorieRepository.saveAll(Arrays.asList(cat1, cat2));
            System.out.println("Catégories initialisées.");
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

                ModuleRepository.saveAll(Arrays.asList(module1, module2));
                System.out.println("Modules d'exemple initialisés.");
            } else {
                System.out.println("Erreur : Categorie 'Programming' non retrouvée");
            }
        }
    }


    private void initializeLecons() {
        // Vérifie si des leçons existent déjà
        if (leconsRepository.findAll().isEmpty()) {
            Optional<Module> moduleOptional = ModuleRepository.findById(1L);
            if (moduleOptional.isPresent()) {
                Module module = moduleOptional.get();
                // Création de la première leçon
                Lecons lecons1 = new Lecons();
                lecons1.setTitre("Nouvelle Leçon");
                lecons1.setDescription("Description de la nouvelle leçon");
                lecons1.setContenu("Vidéo de la Leçon");
                lecons1.setModule(module);
                // Création du quiz associé à la première leçon
                Quiz quiz1 = new Quiz();
                quiz1.setQuestions("Quelles sont les bases de Spring Boot?");
                quiz1.setLecon(lecons1);
                lecons1.setQuiz(quiz1); // Association du quiz à la leçon

                // Création de la deuxième leçon
                Lecons lecons2 = new Lecons();
                lecons2.setTitre("Nouvelle Leçon 2");
                lecons2.setDescription("Description de la deuxième leçon");
                lecons2.setContenu("Contenu de la deuxième leçon");
                lecons2.setModule(module);

                // Création du quiz associé à la deuxième leçon
                Quiz quiz2 = new Quiz();
                quiz2.setQuestions("Quels sont les avantages de Spring Boot?");
                quiz2.setLecon(lecons2);
                lecons2.setQuiz(quiz2);

                // Sauvegarde des leçons et des quiz
                leconsRepository.saveAll(Arrays.asList(lecons1, lecons2));
                System.out.println("Leçons et quiz créés et associés au module : " + module.getTitre());
            } else {
                System.out.println("Aucun module trouvé pour attribuer les leçons.");
            }
        } else {
            System.out.println("Leçons déjà créées. Initialisation des leçons sautée.");
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
                defaultAdmin.setEmail("admin@gmail.com");
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
