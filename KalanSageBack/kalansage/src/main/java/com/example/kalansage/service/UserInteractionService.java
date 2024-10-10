package com.example.kalansage.service;

import com.example.kalansage.model.Module;
import com.example.kalansage.model.*;
import com.example.kalansage.model.userAction.*;
import com.example.kalansage.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserInteractionService {

    @Autowired
    private UserTestRepository userTestRepository;
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private UserProgressRepository userProgressRepository;
    @Autowired
    private UserLeconRepository userLeconRepository;
    @Autowired
    private LeconsRepository leconsRepository;
    @Autowired
    private UserModuleRepository userModuleRepository;

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ModuleRepository moduleRepository;
    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private UserAbonnementRepository userAbonnementRepository;
    @Autowired
    private BadgeRepository badgeRepository;
    @Autowired
    private UserBadgeRepository userBadgeRepository;
    @Autowired
    private EvaluationRepository evaluationRepository;


    // Gérer l'interaction avec le test
    public UserTest passerTest(Long userId, Long testId, int score) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Test> test = testRepository.findById(testId);

        if (user.isPresent() && test.isPresent()) {
            UserTest userTest = new UserTest();
            userTest.setUser(user.get());
            userTest.setTest(test.get());
            userTest.setScore(score);
            userTest.setDateTentative(new Date());
            return userTestRepository.save(userTest);
        } else {
            throw new RuntimeException("Utilisateur ou Test introuvable.");
        }
    }

    public Optional<UserTest> getUserTest(Long userTestId) {
        return userTestRepository.findById(userTestId);
    }

    // Gérer la progression de l'utilisateur
    public UserProgress creerProgressionUtilisateur(Long userId, int pointsGagnes) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            UserProgress userProgress = new UserProgress();
            userProgress.setUser(user.get());
            userProgress.setPointsGagne(pointsGagnes);
            userProgress.setStatus(ProgressStatus.EN_COURS);
            userProgress.setDateProgress(new Date());

            return userProgressRepository.save(userProgress);
        } else {
            throw new RuntimeException("Utilisateur introuvable.");
        }
    }

    public Optional<UserProgress> getUserProgress(Long userProgressId) {
        return userProgressRepository.findById(userProgressId);
    }

    public void mettreAJourProgressionUtilisateur(Long userProgressId, int pointsAdditionnels) {
        Optional<UserProgress> userProgress = userProgressRepository.findById(userProgressId);

        if (userProgress.isPresent()) {
            UserProgress progression = userProgress.get();
            progression.setPointsGagne(progression.getPointsGagne() + pointsAdditionnels);
            userProgressRepository.save(progression);
        } else {
            throw new RuntimeException("Progression de l'utilisateur introuvable.");
        }
    }

    // Gérer l'interaction avec la leçon
    public UserLecon completerLecon(Long userId, Long leconId, int pointsGagnes) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Lecons> lecon = leconsRepository.findById(leconId);
        if (user.isPresent() && lecon.isPresent()) {
            UserLecon userLecon = new UserLecon();
            userLecon.setUser(user.get());
            userLecon.setLecons(lecon.get());
            userLecon.setPointsGagnes(pointsGagnes);
            userLecon.setCompletionDate(new Date());
            return userLeconRepository.save(userLecon);
        } else {
            throw new RuntimeException("Utilisateur ou Leçon introuvable.");
        }
    }

    public Optional<UserLecon> getUserLecon(Long userLeconId) {
        return userLeconRepository.findById(userLeconId);
    }

    // Gérer l'interaction avec le module
    public UserModule completerModule(Long userId, Long moduleId, int pointsGagnes) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Module> module = moduleRepository.findById(moduleId);
        if (user.isPresent() && module.isPresent()) {
            UserModule userModule = new UserModule();
            userModule.setUser(user.get());
            userModule.setModule(module.get());
            userModule.setCompletionDate(new Date());
            return userModuleRepository.save(userModule);
        } else {
            throw new RuntimeException("Utilisateur ou Module introuvable.");
        }
    }

    public Optional<UserModule> getUserModule(Long userModuleId) {
        return userModuleRepository.findById(userModuleId);
    }

    public UserModule inscrireAuModule(Long userId, Long moduleId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable."));
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new IllegalArgumentException("Module introuvable."));

        // Check if the user is already enrolled in the module
        if (userModuleRepository.existsByUserAndModule(user, module)) {
            throw new IllegalArgumentException("L'utilisateur est déjà inscrit à ce module.");
        }

        UserModule userModule = new UserModule();
        userModule.setUser(user);
        userModule.setModule(module);
        userModule.setDateInscription(new Date());

        return userModuleRepository.save(userModule);
    }

    // Gérer l'interaction avec l'abonnement
    public UserAbonnement sAbonner(Long userId, Long abonnementId) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Abonnement> abonnement = abonnementRepository.findById(abonnementId);

        if (user.isEmpty() || abonnement.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur ou Abonnement introuvable.");
        }
        // Check if the user is already subscribed to this abonnement
        Optional<UserAbonnement> existingSubscription = userAbonnementRepository.findByUser_IdAndAbonnement_IdAbonnement(userId, abonnementId);
        if (existingSubscription.isPresent()) {
            throw new IllegalStateException("Vous avez déjà cet abonnement ! 🤗.");
        }
        UserAbonnement userAbonnement = new UserAbonnement();
        userAbonnement.setUser(user.get());
        userAbonnement.setAbonnement(abonnement.get());
        userAbonnement.setStartDate(new Date());

        return userAbonnementRepository.save(userAbonnement);
    }


    public long countAbonnements() {
        return userAbonnementRepository.count();
    }

    // Gérer l'obtention d'un badge
    public UserBadge obtenirBadge(Long userId, Long badgeId) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Badge> badge = badgeRepository.findById(badgeId);

        if (user.isEmpty() || badge.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur ou Badge introuvable.");
        }
        UserBadge userBadge = new UserBadge();
        userBadge.setUser(user.get());
        userBadge.setBadge(badge.get());
        userBadge.setDateEarned(new Date());

        return userBadgeRepository.save(userBadge);
    }

    // Soumettre une évaluation
    public Evaluation soumettreEvaluation(Long userId, Long courseId, String commentaire, int etoiles) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Module> cours = moduleRepository.findById(courseId);

        if (user.isEmpty() || cours.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur ou Cours introuvable.");
        }
        Evaluation evaluation = new Evaluation();
        evaluation.setUserId(userId);
        evaluation.setModule(cours.get());
        evaluation.setCommentaire(commentaire);
        evaluation.setEtoiles(etoiles);

        return evaluationRepository.save(evaluation);
    }

    // Mettre à jour les points et vérifier les badges
    public void mettreAJourPoints(Long userId, int pointsGagnes) {
        Optional<UserProgress> userProgressOpt = userProgressRepository.findByUser_Id(userId);
        if (userProgressOpt.isPresent()) {
            UserProgress userProgress = userProgressOpt.get();
            userProgress.setPointsGagne(userProgress.getPointsGagne() + pointsGagnes);
            userProgress.setDateProgress(new Date());
            userProgressRepository.save(userProgress);

            verifierPourBadge(userId, userProgress.getPointsGagne());
        } else {
            // Créer une nouvelle progression de l'utilisateur si elle n'existe pas
            UserProgress userProgress = new UserProgress();
            userProgress.setUser(userRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable.")));
            userProgress.setPointsGagne(pointsGagnes);
            userProgress.setDateProgress(new Date());
            userProgressRepository.save(userProgress);

            verifierPourBadge(userId, pointsGagnes);
        }
    }

    private void verifierPourBadge(Long userId, int pointsActuels) {
        // Logique pour vérifier et attribuer un badge en fonction des points actuels
        if (pointsActuels >= 1000) {
            // Attribuer un badge pour 1000 points, par exemple
            Badge badge = (Badge) badgeRepository.findByNomBadge("Badge 1000 Points")
                    .orElseThrow(() -> new IllegalArgumentException("Badge introuvable."));
            obtenirBadge(userId, badge.getIdBadge());
        }
    }

    public List<User> getUsersByAbonnement(Long abonnementId) {
        return userAbonnementRepository.findUsersByAbonnementId(abonnementId);
    }

    public List<User> getAbonnementUsers() {
        return userAbonnementRepository.findAll().stream()
                .map(UserAbonnement::getUser)
                .collect(Collectors.toList());
    }

    public Abonnement findMostSubscribedAbonnement() {
        List<Abonnement> abonnements = userAbonnementRepository.findMostSubscribedAbonnement();
        return abonnements.isEmpty() ? null : abonnements.get(0);
    }
}
