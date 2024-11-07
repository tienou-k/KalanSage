package com.example.kalansage.service;

import com.example.kalansage.dto.AbonnementDTO;
import com.example.kalansage.dto.UserAbonnementDTO;
import com.example.kalansage.dto.UserDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.*;
import com.example.kalansage.model.userAction.*;
import com.example.kalansage.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    private ReviewRepository reviewRepository;


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
    @Transactional
    public void updateProgress(Long userId, Long moduleId, int progress) {
        UserModule userModule = userModuleRepository.findByUserIdAndModuleId(userId, moduleId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Update progress
        userModule.setProgress(progress);

        // If progress reaches 100, mark as completed
        if (progress == 100) {
            userModule.setCompleted(true);
            userModule.setCompletionDate(new Date());
        }

        userModuleRepository.save(userModule);
    }

    public UserModule getUserModule(Long userId, Long moduleId) {
        return userModuleRepository.findByUserIdAndModuleId(userId, moduleId)
                .orElseThrow(() -> new RuntimeException("UserModule not found"));
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
    public ResponseEntity<?> sAbonner(Long userId, Long abonnementId) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Abonnement> abonnement = abonnementRepository.findById(abonnementId);

        if (user.isEmpty() || abonnement.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                    "L'utilisateur ou l'abonnement spécifié est introuvable. Veuillez vérifier les informations et réessayer."
            );
        }

        Optional<UserAbonnement> existingSubscription = userAbonnementRepository
                .findByUser_IdAndAbonnement_IdAbonnement(userId, abonnementId);
        if (existingSubscription.isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(
                    "Vous êtes déjà abonné à ce service ! 😊."
            );
        }

        UserAbonnement userAbonnement = new UserAbonnement();
        userAbonnement.setUser(user.get());
        userAbonnement.setAbonnement(abonnement.get());
        userAbonnement.setStartDate(new Date());

        userAbonnementRepository.save(userAbonnement);

        return ResponseEntity.ok(
                "Félicitations ! 💪 Vous êtes maintenant abonné à " + abonnement.get().getTypeAbonnement() + ". Profitez-en !"
        );
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
    public Review soumettreReview(Long userId, Long courseId, String commentaire, int etoiles) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Module> cours = moduleRepository.findById(courseId);
        if (user.isEmpty() || cours.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur ou Cours introuvable.");
        }
        Review review = new Review();
        review.setUserId(userId);
        review.setModule(cours.get());
        review.setCommentaire(commentaire);
        review.setEtoiles(etoiles);
        return reviewRepository.save(review);
    }


    private void verifierPourBadge(Long userId, int pointsActuels) {
        if (pointsActuels >= 1000) {
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

    public Abonnement getMostSubscribedAbonnement() {
        List<Abonnement> abonnements = userAbonnementRepository.getMostSubscribedAbonnement();
        return abonnements.isEmpty() ? null : abonnements.get(0);
    }

    public List<Module> getModulesForUser(long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        // Fetch all modules where the user is enrolled
        List<UserModule> enrollments = userModuleRepository.findByUserId(userId);
        List<Module> modules = enrollments.stream()
                .map(UserModule::getModule)
                .collect(Collectors.toList());
        return modules;
    }

    public boolean isUserAlreadyEnrolled(Long userId, Long moduleId) {
        return userModuleRepository.existsByUserIdAndModuleId(userId, moduleId);
    }

    public List<UserAbonnement> getUserAbonnementsByUserId(Long userId) {
        return userAbonnementRepository.findByUserId(userId);
    }

    public boolean userExists(Long userId) {
        return userRepository.existsById(userId);
    }

    public List<UserAbonnementDTO> convertToDTO(List<UserAbonnement> userAbonnements) {
        return userAbonnements.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    private UserAbonnementDTO mapToDto(UserAbonnement userAbonnement) {
        UserAbonnementDTO dto = new UserAbonnementDTO();
        dto.setId(userAbonnement.getId());
        dto.setStartDate(userAbonnement.getStartDate());
        dto.setEndDate(userAbonnement.getEndDate());
        dto.setActive(userAbonnement.isActive());

        // Set UserDTO
        UserDTO userDto = new UserDTO();
        userDto.setId(userAbonnement.getUser().getId());
        userDto.setNom(userAbonnement.getUser().getNom());
        userDto.setPrenom(userAbonnement.getUser().getPrenom());
        userDto.setUsername(userAbonnement.getUser().getUsername());
        userDto.setEmail(userAbonnement.getUser().getEmail());
        userDto.setTelephone(userAbonnement.getUser().getTelephone());
        userDto.setDateInscription(userAbonnement.getUser().getDateInscription());


        dto.setUser(userDto);

        // Set AbonnementDTO
        AbonnementDTO abonnementDto = new AbonnementDTO();
        abonnementDto.setIdAbonnement(userAbonnement.getAbonnement().getIdAbonnement());
        abonnementDto.setTypeAbonnement(userAbonnement.getAbonnement().getTypeAbonnement());
        abonnementDto.setPrix(userAbonnement.getAbonnement().getPrix());
        abonnementDto.setDateExpiration(userAbonnement.getAbonnement().getDateExpiration());
        abonnementDto.setStatut(userAbonnement.getAbonnement().getStatut());
        abonnementDto.setDescription(userAbonnement.getAbonnement().getDescription());
        dto.setAbonnement(abonnementDto);

        return dto;
    }
}
