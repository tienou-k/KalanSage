package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBookmark;
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



    @Override
    public Module creerModule(Module module) {
        // Check if a module with the same title already exists
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
    // Get all modules
    public List<ModulesDTO> getAllModules() {
        List<Module> modules = moduleRepository.findAll();
        return convertToDTO(modules);
    }

    // Get module by ID
    public ModulesDTO getModuleById(Long id) {
        Optional<Module> moduleOpt = moduleRepository.findById(id);
        return moduleOpt.map(mod -> new ModulesDTO(
                mod.getId(),
                mod.getTitre(),
                mod.getDescription(),
                mod.getPrix(),
                mod.getImageUrl(),
                mod.getDateCreation(),
                mod.getCategorie() != null ? mod.getCategorie().getNomCategorie() : null
        )).orElse(null); // Return null if the module is not found
    }

    // Get modules by category ID
    public List<ModulesDTO> getModulesByCategorie(Long categorieId) {
        Categorie categorie = categorieRepository.findById(categorieId).orElse(null);
        if (categorie != null) {
            List<Module> modules = moduleRepository.findByCategorie(categorie);
            return convertToDTO(modules);
        }
        return List.of(); // Return an empty list if the category is not found
    }

    // Helper method to convert Module list to ModulesDTO list
    private List<ModulesDTO> convertToDTO(List<Module> modules) {
        return modules.stream()
                .map(module -> new ModulesDTO(
                        module.getId(),
                        module.getTitre(),
                        module.getDescription(),
                        module.getPrix(),
                        module.getImageUrl(),
                        module.getDateCreation(),
                        module.getCategorie().getNomCategorie()
                        ))
                .collect(Collectors.toList());
    }

    @Transactional
    public Module modifierModule(Module module) {
        // Check if the lesson exists before updating (can be done in the controller as well)
        Optional<Module> existingModule = moduleRepository.findById(module.getId());
        if (existingModule.isPresent()) {
            return moduleRepository.save(module);  // Save the updated lesson
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

    // Get a course by ID and map it to CoursDTO
    public Optional<ModulesDTO> getModule(Long id) {
        return moduleRepository.findById(id)
                .map(this::mapToModuleDTO);
    }

    // Helper method to map Cours to CoursDTO
    private ModulesDTO mapToModuleDTO(Module module) {
        ModulesDTO moduleDTO = new ModulesDTO();
        moduleDTO.setId(module.getId());
        moduleDTO.setTitre(module.getTitre());
        moduleDTO.setDescription(module.getDescription());
        moduleDTO.setPrix(module.getPrix());
        moduleDTO.setDateCreation(module.getDateCreation());
        moduleDTO.setImageUrl(module.getImageUrl());
        moduleDTO.setNomCategorie(module.getCategorie().getNomCategorie());
        return moduleDTO;
    }


    public Module getModuleModel(Long moduleId) {
        return moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not trouvé"));
    }

    public UserModule inscrireAuModule(Long id, Long moduleId) {
        User user = userRepository.findById(id)
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
    // Get top modules by subscriber count with pagination
    public List<ModulesDTO> getTopModules(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        List<Module> topModules = moduleRepository.findTopModules(pageable);
        return convertToDTO(topModules);
    }
    public long getUserCountByModule(Module  module) {
        return userModuleRepository.countByModule(module);
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

    public List<Module> fetchPopularModules() {
        return userModuleRepository.findTop10ByOrderByUserIdDesc();
    }

}
