package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.repository.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ModuleServiceImpl implements ModuleService {

    @Autowired
    private ModuleRepository moduleRepository;
    @Autowired
    private CategorieRepository categorieRepository;
    @Autowired
    private UserModuleRepository userModuleRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserBookmarkRepository userBookRepository;
    @Autowired
    private LeconsServiceImpl leconsService;

    @Override
    public Module creerModule(Module module) {
        if (moduleRepository.existsByTitre(module.getTitre())) {
            throw new RuntimeException("Un module avec le même titre existe déjà.");
        }
        module.setTitre(module.getTitre().trim());
        module.setDescription(module.getDescription());
        module.setPrix(module.getPrix());
        module.setDateCreation(new Date());
        if (module.getCategorie() != null) {
            Categorie categorie = categorieRepository.findByNomCategorie(module.getCategorie().getNomCategorie())
                    .orElseThrow(() -> new RuntimeException("Categorie n'existe pas !"));
            module.setCategorie(categorie);
        } else {
            throw new RuntimeException("Categorie non spécifiée !");
        }
        return moduleRepository.save(module);
    }

    public List<ModulesDTO> getAllModules() {
        List<Module> modules = moduleRepository.findAll();
        return convertToDTO(modules);
    }

    public ModulesDTO getModuleById(Long id) {
        Optional<Module> moduleOpt = moduleRepository.findById(id);
        return moduleOpt.map(this::mapToModuleDTO).orElse(null);
    }

    public List<ModulesDTO> getModulesByCategorie(Long categorieId) {
        Categorie categorie = categorieRepository.findById(categorieId).orElse(null);
        if (categorie != null) {
            List<Module> modules = moduleRepository.findByCategorie(categorie);
            return convertToDTO(modules);
        }
        return List.of();
    }

    private List<ModulesDTO> convertToDTO(List<Module> modules) {
        return modules.stream()
                .map(this::mapToModuleDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public Module modifierModule(Module module) {
        Optional<Module> existingModule = moduleRepository.findById(module.getId());
        if (existingModule.isPresent()) {
            return moduleRepository.save(module);
        } else {
            throw new EntityNotFoundException("Module avec ID " + module.getId() + " n'existe pas.");
        }
    }

    @Override
    public void supprimerModule(Long id) {
        if (moduleRepository.existsById(id)) {
            moduleRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("Le module avec l'ID " + id + " n'existe pas.");
        }
    }

    public List<ModulesDTO> listerModule() {
        return moduleRepository.findAll().stream()
                .map(this::mapToModuleDTO)
                .collect(Collectors.toList());
    }

    public Optional<ModulesDTO> getModule(Long id) {
        return moduleRepository.findById(id)
                .map(this::mapToModuleDTO);
    }

    private ModulesDTO mapToModuleDTO(Module module) {
        ModulesDTO moduleDTO = new ModulesDTO();
        moduleDTO.setId(module.getId());
        moduleDTO.setTitre(module.getTitre());
        moduleDTO.setDescription(module.getDescription());
        moduleDTO.setPrix(module.getPrix());
        moduleDTO.setDateCreation(module.getDateCreation());
        moduleDTO.setImageUrl(module.getImageUrl());
        moduleDTO.setNomCategorie(module.getCategorie() != null ? module.getCategorie().getNomCategorie() : null);
        // Fetch counts for lecons and module users
        int leconsCount = Math.toIntExact(leconsService.countByModule_Id(module.getId()));
        int moduleUsersCount = Math.toIntExact(userModuleRepository.countByModuleId(module.getId()));

        moduleDTO.setLeconsCount(leconsCount);
        moduleDTO.setModulesUsers(moduleUsersCount);  // Corrected method name

        return moduleDTO;
    }


    public Module getModuleModel(Long moduleId) {
        return moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module non trouvé"));
    }

    public UserModule inscrireAuModule(Long id, Long moduleId) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable."));
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new IllegalArgumentException("Module introuvable."));

        if (userModuleRepository.existsByUserAndModule(user, module)) {
            throw new IllegalArgumentException("L'utilisateur est déjà inscrit à ce module.");
        }
        UserModule userModule = new UserModule();
        userModule.setUser(user);
        userModule.setModule(module);
        userModule.setDateInscription(new Date());
        userModule.setProgress(0);
        userModule.setCompleted(false);

        return userModuleRepository.save(userModule);
    }

    @Override
    public List<Module> getTop5Modules() {
        try {
            return moduleRepository.findTopModules(PageRequest.of(0, 5));
        } catch (Exception e) {
            System.err.println("Error fetching top modules: " + e.getMessage());
            throw new RuntimeException("Unable to fetch top modules.");
        }
    }

    public List<ModulesDTO> getTopModules(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        List<Module> topModules = moduleRepository.findTopModules(pageable);
        return convertToDTO(topModules);
    }

    @Override
    public Long getUserCountByModule(Module module) {
        return userModuleRepository.countByModuleId(module.getId());
    }

    public Module findModuleById(Long moduleId) {
        return moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found with id: " + moduleId));
    }

    public List<Module> getModules() {
        return moduleRepository.findAll();
    }

    public List<Module> getModulesByCategory_Id(Long categoryId) {
        return moduleRepository.findByCategorie_IdCategorie(categoryId);
    }

    public boolean isBookmarked(Long moduleId, Long id) {
        return userBookRepository.existsByModuleIdAndUserId(moduleId, id);
    }

   /* public List<Module> fetchPopularModules() {
        return userModuleRepository.findTop10ByOrderByUserIdDesc();
    }*/

    public List<ModulesDTO> fetchPopularModules() {
        List<Module> popularModules = userModuleRepository.findTop10ByOrderByUserIdDesc();
        return popularModules.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private ModulesDTO convertToDTO(Module module) {
        if (module == null) {
            return null;
        }

        // Fetch counts for lessons and module users
        int leconsCount = Math.toIntExact(leconsService.countByModule_Id(module.getId()));
        int moduleUsersCount = Math.toIntExact(userModuleRepository.countByModuleId(module.getId()));

        // Create a ModulesDTO object
        return new ModulesDTO(
                module.getId(),
                module.getTitre(),
                module.getDescription(),
                module.getPrix(),
                module.getImageUrl(),
                module.getDateCreation(),
                module.getCategorie() != null ? module.getCategorie().getNomCategorie() : null,
                leconsCount,
                moduleUsersCount,
                null // You can replace null with actual users if needed
        );
    }

}
