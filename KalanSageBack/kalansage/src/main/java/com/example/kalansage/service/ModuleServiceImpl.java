package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.UserModuleRepository;
import com.example.kalansage.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
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


    @Override
    public Module creerModule(ModulesDTO ModuleDTO) {
        if (moduleRepository.existsByTitre(ModuleDTO.getTitre())) {
            throw new RuntimeException("Un cours avec le même titre existe déjà.");
        }
        Module Module = new Module();
        Module.setTitre(ModuleDTO.getTitre());
        Module.setDescription(ModuleDTO.getDescription());
        Module.setPrix(ModuleDTO.getPrix());
        Module.setDateCreation(new Date());
        if (ModuleDTO.getNomCategorie() != null) {
            Categorie categorie = categorieRepository.findByNomCategorie(ModuleDTO.getNomCategorie())
                    .orElseThrow(() -> new RuntimeException("Categorie n'existe pas !"));
            Module.setCategorie(categorie);
        } else {
            throw new RuntimeException("Categorie non spécifiée !");
        }

        return moduleRepository.save(Module);
    }


    @Override
    public Optional<Module> trouverModuleParTitre(String titreCours) {
        return moduleRepository.findModuleByTitre(titreCours);
    }

    // ajouterCours dans une categorie
    @Override
    public void ajouterModuleDansCategorie(Module Module, Long idCategorie) {
        Module.add(idCategorie);
    }

    @Override
    public boolean moduleExiste(String titre) {
        return false;
    }

    @Override
    public List<Module> getModuleByCategorie(Long categorieId) {
        Categorie categorie = categorieRepository.findById(categorieId)
                .orElseThrow(() -> new ResourceNotFoundException("Categorie not found"));
        return moduleRepository.findByCategorie(categorie);
    }


    @Override
    public List<Module> getModulePrix(Long prix) {
        return moduleRepository.findCoursByPrix(prix);
    }


    @Override
    public Module modifierModule(Long id, Module updatedModule) {
        Module existingModule = moduleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));
        existingModule.setTitre(updatedModule.getTitre());
        existingModule.setDescription(updatedModule.getDescription());
        existingModule.setPrix(updatedModule.getPrix());
        existingModule.setCategorie(updatedModule.getCategorie());

        return moduleRepository.save(existingModule);
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
    private ModulesDTO mapToModuleDTO(Module Module) {
        ModulesDTO ModuleDTO = new ModulesDTO();
        ModuleDTO.setId(Module.getIdModule());
        ModuleDTO.setTitre(Module.getTitre());
        ModuleDTO.setDescription(Module.getDescription());
        ModuleDTO.setPrix(Module.getPrix());
        ModuleDTO.setDateCreation(Module.getDateCreation());
        ModuleDTO.setNomCategorie(Module.getCategorie() != null ? Module.getCategorie().getNomCategorie() : null);
        return ModuleDTO;
    }

    public Module getModuleModel(Long moduleId) {
        return moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not trouvé"));
    }


    public UserModule inscrireAuModule(Long userId, Long moduleId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur introuvable."));
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new IllegalArgumentException("Module introuvable."));

        // Check if the user is already enrolled in the module
        if (userModuleRepository.existsByUserAndModules(user, module)) {
            throw new IllegalArgumentException("L'utilisateur est déjà inscrit à ce module.");
        }
        UserModule userModule = new UserModule();
        userModule.setUser(user);
        userModule.setModules(module);
        userModule.setDateInscription(new Date());
        userModule.setProgress(0);
        userModule.setCompleted(false);

        return userModuleRepository.save(userModule);
    }


    @Override
    public List<Module> getTop5Modules() {
        return moduleRepository.findTopModules(PageRequest.of(0, 5));
    }
}