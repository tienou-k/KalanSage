package com.example.kalansage.controller;

import com.example.kalansage.model.FileInfo;
import com.example.kalansage.model.Partenaire;
import com.example.kalansage.repository.PartenaireRepository;
import com.example.kalansage.service.FilesStorageServiceImpl;
import com.example.kalansage.service.PartenaireService;
import com.example.kalansage.service.PartenaireServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/admins/partenaires")
public class PartenaireController {
    @Autowired
    private PartenaireService partenaireService;
    @Autowired
    private PartenaireServiceImpl partenaireServiceImpl;
    @Autowired
    private FilesStorageServiceImpl filesystemService;
    @Autowired
    private PartenaireRepository partenaireRepository;

    @PostMapping(value = "/creer-partenariat", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Partenaire> creerPartenariat(
            @RequestPart("partenaire") String partenaireJson,
            @RequestPart("file") MultipartFile file) {
        try {
            // Parse the JSON string to the Partenaire object
            ObjectMapper objectMapper = new ObjectMapper();
            Partenaire partenaire = objectMapper.readValue(partenaireJson, Partenaire.class);

            // Handle the file upload
            FileInfo fileInfo = filesystemService.saveFile(file);
            partenaire.setFileInfos(fileInfo);

            // Set additional Partenaire details
            partenaire.setDateAjoute(new Date());

            // Save the Partenaire to the database
            Partenaire savedPartenaire = partenaireRepository.save(partenaire);

            return ResponseEntity.ok(savedPartenaire);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/modifier-partenariat/{id}")
    public ResponseEntity<Partenaire> modifierPartenariat(@PathVariable Long id, @RequestBody Partenaire partenaire) {
        Partenaire updatedPartenaire = partenaireService.modifierPartenariat(id, partenaire);
        return ResponseEntity.ok(updatedPartenaire);
    }

    @DeleteMapping("/supprimer-partenariat/{id}")
    public ResponseEntity<Void> supprimerPartenariat(@PathVariable Long id) {
        partenaireService.supprimerPartenariat(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/activer-desactiver-partenariat/{id}")
    public ResponseEntity<Partenaire> activerDesactiverPartenariat(@PathVariable Long id, @RequestParam boolean statut) {
        Partenaire updatedPartenaire = partenaireService.activerDesactiverPartenariat(id, statut);
        return ResponseEntity.ok(updatedPartenaire);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Partenaire>> getPartenaireById(@PathVariable Long id) {
        return ResponseEntity.ok(partenaireService.getPartenaireById(id));
    }

    @GetMapping("/list-partenaires")
    public ResponseEntity<List<Partenaire>> listerPartenaires() {
        List<Partenaire> partenaires = partenaireService.listerPartenaires();
        return ResponseEntity.ok(partenaires);
    }

    @GetMapping("/count")
    public ResponseEntity<Long> countPartenaires() {
        Long count = partenaireServiceImpl.countAllPartenaires();
        return ResponseEntity.ok(count);
    }
}
