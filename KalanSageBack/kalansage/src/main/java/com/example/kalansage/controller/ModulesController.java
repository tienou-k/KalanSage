package com.example.kalansage.controller;



import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.*;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.userAction.UserModule;
import com.example.kalansage.repository.CategorieRepository;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.service.FilesStorageServiceImpl;
import com.example.kalansage.service.LeconsService;
import com.example.kalansage.service.ModuleService;
import com.example.kalansage.service.ModuleServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/api/modules")
public class ModulesController {

    @Autowired
    private ModuleService modulesservice;

    @Autowired
    private ModuleRepository modulesRepository;

    @Autowired
    private LeconsRepository leconsRepository;
    @Autowired
    private LeconsService leconsService;
    @Autowired
    private FilesStorageServiceImpl filesStorageService;
    @Autowired
    private CategorieRepository categorieRepository;
    @Autowired
    private ModuleServiceImpl moduleServiceimpl;


    // Method for creating a module, including image upload
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping(path = "/creer-module", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> creerModule(
            @RequestParam("titre") String titre,
            @RequestParam("description") String description,
            @RequestParam("prix") String prix,
            @RequestParam("nomCategorie") String nomCategorie,
            @RequestParam(value = "file", required = false) MultipartFile file) throws IOException {

        // Validate category ID
        try {
            Optional<Categorie> categorie = categorieRepository.findByNomCategorie(nomCategorie);

            if (categorie.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Collections.singletonMap("message", "Categorie avec  " + nomCategorie + " n'existe pas!"));
            }

            FileInfo fileInfo = null;
            if (file != null && !file.isEmpty()) {
                String fileExtension = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
                if (!fileExtension.equalsIgnoreCase("png") && !fileExtension.equalsIgnoreCase("jpg")
                        && !fileExtension.equalsIgnoreCase("jpeg")) {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(Collections.singletonMap("message", "The file must be in PNG or JPEG format."));
                }
                String renamedFile = titre.replace("", "") + "1." + fileExtension;
                fileInfo = filesStorageService.saveFileInSpecificFolderWithCustomName(file, "", renamedFile);
            }

            Module module = new Module();
            module.setTitre(titre);
            module.setDescription(description);
            module.setPrix(Double.parseDouble(prix)); // Convert BigDecimal to double
            module.setDateCreation(new Date());
            module.setCategorie(categorie.get());
            module.setImageUrl(fileInfo != null ? fileInfo.getUrl() : null);

            try {
                Module createdModule = modulesservice.creerModule(module);
                return ResponseEntity.ok(createdModule);
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Collections.singletonMap("message", "An error occurred while creating the module: " + e.getMessage()));
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Nom de categorie invalid ");
        }
    }

    // Helper method to extract file extension
    private String getExtension(String filename) {
        return filename.substring(filename.lastIndexOf('.') + 1);
    }
    //update module method
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PutMapping(path = "/modifier-module/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> modifierModule(
            @PathVariable(value = "id", required = false) Long id,
            @RequestParam(value = "titre", required = false) String titre,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "prix", required = false) Double prix,
            @RequestParam(value = "file", required = false) MultipartFile file) throws IOException {

        // Verify if the module exists
        Optional<Module> existingModuleOpt = modulesRepository.findById(id);
        if (existingModuleOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("message", "Module avec ID " + id + " n'existe pas!"));
        }
        Module existingModule = existingModuleOpt.get();
        // Update title only if it's provided
        if (titre != null && !titre.isEmpty()) {
            existingModule.setTitre(titre);
        }
        // Update description only if it's provided
        if (description != null && !description.isEmpty()) {
            existingModule.setDescription(description);
        }
        // Update price only if it's provided
        if (prix != null) {
            existingModule.setPrix(prix);
        }
        FileInfo fileInfo = null;
        if (file != null && !file.isEmpty()) {
            // Validate the image type (only allow png, jpeg, or jpg)
            String fileExtension = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
            if (!fileExtension.equalsIgnoreCase("png") && !fileExtension.equalsIgnoreCase("jpeg")
                    && !fileExtension.equalsIgnoreCase("jpg")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Collections.singletonMap("message", "Oups ! le fichier doit être au format png, jpeg."));
            }
            // Rename the file according to a specific format (e.g., titre_module1.png)
            String renamedFile = (titre != null ? titre : existingModule.getTitre()).replace(" ", "_") + "1." + fileExtension;
            // Save the file to a specific folder
            String specificFolderPath = "";  // Adjust path as needed
            fileInfo = filesStorageService.saveFileInSpecificFolderWithCustomName(file, specificFolderPath, renamedFile);
            // Update the image path if a new file is provided
            existingModule.setImageUrl(fileInfo != null ? fileInfo.getUrl() : existingModule.getImageUrl());
        }
        // Save the updated module
        Module updatedModule = modulesservice.modifierModule(existingModule);
        return ResponseEntity.ok(updatedModule);
    }


    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/suprimer-module/{id}")
    public ResponseEntity<?> supprimerModule(@PathVariable Long id) {
        // Logic to delete the module by id
        Optional<Module> moduleOptional = modulesRepository.findById(id);
        if (moduleOptional.isPresent()) {
            modulesRepository.delete(moduleOptional.get());
            return ResponseEntity.ok(Collections.singletonMap("message", "Module supprimé successfully."));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("message", "Oups Module "+id+ " n'existe pas !."));
        }
    }


    @GetMapping("/module-par/{id}")
    public ResponseEntity<Optional<ModulesDTO>> getModule(@PathVariable Long id) {
        return ResponseEntity.ok(modulesservice.getModule(id));
    }


    @GetMapping("/list-modules")
    public ResponseEntity<List<ModulesDTO>> listerModules() {
        return ResponseEntity.ok(modulesservice.listerModule());
    }

    @PostMapping("/inscris-module/{userId}/{moduleId}")
    public ResponseEntity<?> enrollUserInModule(@PathVariable Long userId, @PathVariable Long moduleId) {
        try {
            UserModule userModule = moduleServiceimpl.inscrireAuModule(userId, moduleId);
            return ResponseEntity.ok(userModule);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/{moduleId}/lecons")
    public ResponseEntity<List<Lecons>> getLeconsByModule(@PathVariable Long moduleId) {
        List<Lecons> leconsList = leconsService.findByModule_Id(moduleId);
        // Log the fetched lessons for debugging
        System.out.println("Fetched lessons for module " + moduleId + ": " + leconsList);
        return ResponseEntity.ok(leconsList);
    }


    @GetMapping("/{moduleId}/lecons/count")
    public ResponseEntity<Long> getLeconsCountByModule(@PathVariable Long moduleId) {
        Long leconsCount = leconsService.countByModule_Id(moduleId);
        return ResponseEntity.ok(leconsCount);
    }
    @GetMapping("/{moduleId}/user-count")
    public ResponseEntity<Long> getUserCountByModule(@PathVariable Long moduleId) {
        Module module = moduleServiceimpl.findModuleById(moduleId);
        long userCount = moduleServiceimpl.getUserCountByModule(module);
        return ResponseEntity.ok(userCount);
    }

    @GetMapping("/modules")
    public List<ModulesDTO> getModules() {
        List<Module> modules = moduleServiceimpl.getModules();
        return modules.stream()
                .map(this::mapToModuleDTO)
                .peek(moduleDTO -> System.out.println(moduleDTO.getImageUrl()))
                .collect(Collectors.toList());
    }

    // Mapping to DTO
    private ModulesDTO mapToModuleDTO(Module module) {
        ModulesDTO moduleDTO = new ModulesDTO();
        moduleDTO.setId(module.getId());
        moduleDTO.setTitre(module.getTitre());
        moduleDTO.setDescription(module.getDescription());
        moduleDTO.setPrix(module.getPrix());
        moduleDTO.setDateCreation(module.getDateCreation());

        moduleDTO.setImageUrl(module.getImageUrl()); return moduleDTO;
    }


//------
@GetMapping
public ResponseEntity<List<ModulesDTO>> getAllModules() {
    List<ModulesDTO> modules = moduleServiceimpl.getAllModules();
    return ResponseEntity.ok(modules);
}

    @GetMapping("/{id}")
    public ResponseEntity<?> getModuleById(@PathVariable Long id) {
        ModulesDTO module = moduleServiceimpl.getModuleById(id); // Assuming this method returns null if not found
        if (module != null) {
            return ResponseEntity.ok(module); // Return the found module
        } else {
            // Return a response with a custom message
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("message", "Module avec ID " + id + " n'existe pas!"));
        }
    }

    @GetMapping("/category/{categorieId}")
    public ResponseEntity<List<ModulesDTO>> getModulesByCategory(@PathVariable Long categorieId) {
        List<ModulesDTO> modules = moduleServiceimpl.getModulesByCategorie(categorieId);
        return ResponseEntity.ok(modules);
    }
    @GetMapping("/{moduleId}/isBookmarked/{userId}")
    public ResponseEntity<Boolean> isBookmarked(@PathVariable Long moduleId, @PathVariable Long userId) {
        try {
            boolean isBookmarked = moduleServiceimpl.isBookmarked(moduleId, userId);
            return ResponseEntity.ok(isBookmarked);
        } catch (Exception e) {
            log.error("Error checking bookmark status for module {} and user {}", moduleId, userId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/popular")
    public ResponseEntity<List<Module>> getPopularModules() {
        List<Module> popularModules = moduleServiceimpl.fetchPopularModules();
        return ResponseEntity.ok(popularModules);
    }

}
