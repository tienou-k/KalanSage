package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.repository.ModuleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ModuleServiceImpl implements ModuleService {

    @Autowired
    private ModuleRepository ModuleRepository;
    @Autowired
    private CategorieRepository categorieRepository;


    @Override
    public Module creerModule(ModulesDTO ModuleDTO) {
        if (ModuleRepository.existsByTitre(ModuleDTO.getTitre())) {
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

        return ModuleRepository.save(Module);
    }


    @Override
    public Optional<Module> trouverModuleParTitre(String titreCours) {
        return ModuleRepository.findModuleByTitre(titreCours);
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
        return ModuleRepository.findByCategorie(categorie);
    }


    @Override
    public List<Module> getModulePrix(Long prix) {
        return ModuleRepository.findCoursByPrix(prix);
    }


    @Override
    public Module modifierModule(Long id, Module updatedModule) {
        Module existingModule = ModuleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));
        existingModule.setTitre(updatedModule.getTitre());
        existingModule.setDescription(updatedModule.getDescription());
        existingModule.setPrix(updatedModule.getPrix());
        existingModule.setCategorie(updatedModule.getCategorie());

        return ModuleRepository.save(existingModule);
    }


    @Override
    public void supprimerModule(Long id) {
        if (ModuleRepository.existsById(id)) {
            ModuleRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("Le module avec l'ID " + id + " n'existe pas.");
        }
    }

    public List<ModulesDTO> listerModule() {
        return ModuleRepository.findAll().stream()
                .map(this::mapToModuleDTO)
                .collect(Collectors.toList());
    }

    // Get a course by ID and map it to CoursDTO
    public Optional<ModulesDTO> getModule(Long id) {
        return ModuleRepository.findById(id)
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
        return ModuleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not trouvé"));
    }

}