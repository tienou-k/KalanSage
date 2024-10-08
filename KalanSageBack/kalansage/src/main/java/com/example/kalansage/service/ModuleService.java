package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.userAction.UserModule;

import java.util.List;
import java.util.Optional;

public interface ModuleService {
    Module creerModule(ModulesDTO module);

    Module modifierModule(Long id, ModulesDTO modules);

    void supprimerModule(Long idModule);


    Optional<Module> trouverModuleParTitre(String titreModule);

    // ajouterModule dans une categorie
    void ajouterModuleDansCategorie(Module modules, Long idCategorie);

    Optional<ModulesDTO> getModule(Long id);

    List<ModulesDTO> listerModule();

    boolean moduleExiste(String titre);

    List<Module> getModuleByCategorie(Long categorieId);

    List<Module> getModulePrix(Long prix);


    UserModule inscrireAuModule(Long userId, Long moduleId);

    List<Module> getTop5Modules();
}
