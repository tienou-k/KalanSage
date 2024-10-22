package com.example.kalansage.service;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.userAction.UserModule;

import java.util.List;
import java.util.Optional;

public interface ModuleService {
    Module creerModule(Module module);
    Module modifierModule(Module modules);
    void supprimerModule(Long idModule);
    Optional<ModulesDTO> getModule(Long id);
    List<ModulesDTO> listerModule();
    UserModule inscrireAuModule(Long userId, Long moduleId);
    List<Module> getTop5Modules();
    List<Module> getModulesByCategory_Id(Long id);
    Module getModuleById(Long moduleId);
}
