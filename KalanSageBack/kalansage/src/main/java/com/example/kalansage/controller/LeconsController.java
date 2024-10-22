package com.example.kalansage.controller;

import com.example.kalansage.dto.ModulesDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.FileInfo;
import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.service.FilesStorageServiceImpl;
import com.example.kalansage.service.LeconsService;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

@Slf4j
@RestController
@RequestMapping(value = "/api/lecons", produces = "application/json")
public class LeconsController {

    @Autowired
    private LeconsService leconsService;
    @Autowired
    private FilesStorageServiceImpl filesStorageService;

    @Autowired
    private LeconsRepository leconsRepository;
    @Autowired
    private ModuleRepository moduleRepository;


    // Method for creating a lecon, including video upload
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping(path = "/creer-lecon", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> creerLecon(
            @RequestParam("titre") String titre,
            @RequestParam("description") String description,
            @RequestParam("moduleId") Long moduleId,
            @RequestParam(value = "file") MultipartFile file) throws IOException {

        // Verify if the category exists
        Optional<Module> module = moduleRepository.findById(moduleId);
        if (module.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Collections.singletonMap("message", "Module avec ID " + moduleId + " n'exist pas!"));
        }

        FileInfo fileInfo = null;
        if (file != null && !file.isEmpty()) {
            // Validate the video type (only allow mp4 or mov for example)
            String fileExtension = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
            if (!fileExtension.equalsIgnoreCase("mp4") && !fileExtension.equalsIgnoreCase("mov")
                    && !fileExtension.equalsIgnoreCase("avi")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Collections.singletonMap("message", "Ousp ! le fichier doit être mp4 mov ou format  avi. "));
            }

            // Rename the file according to a specific format (e.g., titre_module1.png)
            String renamedFile = titre.replace(" ", "_") + "1." + fileExtension;

            // Save the file to a specific folder
            String specificFolderPath = "";
            fileInfo = filesStorageService.saveFileInSpecificFolderWithCustomNameVideo(file, specificFolderPath, renamedFile);
        }

        // Create and save the module
        Lecons lecon = new Lecons();
        lecon.setTitre(titre);
        lecon.setDescription(description);
        lecon.setDateAjout(new Date());
        lecon.setModule(module.get());
        lecon.setVideoPath(fileInfo != null ? fileInfo.getUrl() : null);

        Lecons createdLecon = leconsService.creerLecon(lecon);
        return ResponseEntity.ok(createdLecon);
    }

    // Helper method to extract file extension
    private String getExtension(String filename) {
        return filename.substring(filename.lastIndexOf('.') + 1);
    }

    // Method for getting all lessons of a specific module
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PutMapping(path = "/modifier-lecon/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> modifierLecon(
            @PathVariable(value = "id", required = false) Long id,
            @RequestParam(value = "titre", required = false) String titre,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "file", required = false) MultipartFile file) throws IOException {

        // Verify if the lesson exists
        Optional<Lecons> existingLeconOpt = leconsRepository.findById(id);
        if (existingLeconOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonMap("message", "Leçon avec ID " + id + " n'existe pas!"));
        }
        Lecons existingLecon = existingLeconOpt.get();
        // Update title only if it's provided
        if (titre != null && !titre.isEmpty()) {
            existingLecon.setTitre(titre);
        }
        // Update description only if it's provided
        if (description != null && !description.isEmpty()) {
            existingLecon.setDescription(description);
        }
        FileInfo fileInfo = null;
        if (file != null && !file.isEmpty()) {
            // Validate the video type (only allow mp4, mov, or avi)
            String fileExtension = getExtension(Objects.requireNonNull(file.getOriginalFilename()));
            if (!fileExtension.equalsIgnoreCase("mp4") && !fileExtension.equalsIgnoreCase("mov")
                    && !fileExtension.equalsIgnoreCase("avi")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Collections.singletonMap("message", "Oups ! le fichier doit être au format mp4, mov ou avi."));
            }
            // Rename the file according to a specific format (e.g., titre_lecon1.mp4)
            String renamedFile = (titre != null ? titre : existingLecon.getTitre()).replace(" ", "_") + "1." + fileExtension;
            // Save the file to a specific folder
            String specificFolderPath = "";  // Adjust path as needed
            fileInfo = filesStorageService.saveFileInSpecificFolderWithCustomNameVideo(file, specificFolderPath, renamedFile);
            // Update the video path if a new file is provided
            existingLecon.setVideoPath(fileInfo != null ? fileInfo.getUrl() : existingLecon.getVideoPath());
        }
        // Save the updated lesson
        Lecons updatedLecon = leconsService.modifierLecon(existingLecon);
        return ResponseEntity.ok(updatedLecon);
    }



    @DeleteMapping("/supprimer-lecon/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> deleteLecon(@PathVariable Long id) {
        leconsService.supprimerLecon(id);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("/count")
    public ResponseEntity<Long> countLecons() {
        long count = leconsRepository.count();
        return ResponseEntity.ok(count);
    }

    @GetMapping("/lecon-par/{id}")
    public ResponseEntity<Lecons> getLeconById(@PathVariable Long id) {
        Lecons lecon = leconsService.getLeconById(id);
        return ResponseEntity.ok(lecon);
    }

    @GetMapping("/list-lecons")
    public ResponseEntity<List<Lecons>> listerLecons() {
        return ResponseEntity.ok(leconsService.listerLecons());
    }
}
