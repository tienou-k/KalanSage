package com.example.kalansage.service;

import com.example.kalansage.model.FileInfo;
import com.example.kalansage.model.Partenaire;
import com.example.kalansage.repository.PartenaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class PartenaireServiceImpl implements PartenaireService {
    @Autowired
    private PartenaireRepository partenaireRepository;
    @Autowired
    private FilesStorageServiceImpl filesStorageService;


    @Override
    public Partenaire creerPartenariat(Partenaire partenaire, MultipartFile logoFile) throws IOException, IOException {
        partenaire.setDateAjoute(new Date());

        // Save the logo file
        if (logoFile != null && !logoFile.isEmpty()) {
            FileInfo fileInfo = filesStorageService.saveFile(logoFile);
            partenaire.setFileInfos(fileInfo);
        }

        return partenaireRepository.save(partenaire);
    }

    @Override
    public Partenaire modifierPartenariat(Long id, Partenaire partenaire) {
        Optional<Partenaire> existingPartenaire = partenaireRepository.findById(id);
        if (existingPartenaire.isPresent()) {
            Partenaire updatedPartenaire = existingPartenaire.get();
            updatedPartenaire.setNomPartenaire(partenaire.getNomPartenaire());
            updatedPartenaire.setTypePartenaire(partenaire.getTypePartenaire());
            updatedPartenaire.setAdresse(partenaire.getAdresse());
            updatedPartenaire.setEmailContact(partenaire.getEmailContact());
            updatedPartenaire.setNumeroContact(partenaire.getNumeroContact());
            updatedPartenaire.setDescriptionPartenariat(partenaire.getDescriptionPartenariat());
            updatedPartenaire.setCertificationsAccordees(partenaire.getCertificationsAccordees());
            updatedPartenaire.setFileInfos(partenaire.getFileInfos());
            return partenaireRepository.save(updatedPartenaire);
        } else {
            throw new IllegalArgumentException("Partenaire introuvable.");
        }
    }

    @Override
    public void supprimerPartenariat(Long id) {
        partenaireRepository.deleteById(id);
    }

    @Override
    public Partenaire activerDesactiverPartenariat(Long id, boolean statut) {
        Optional<Partenaire> partenaire = partenaireRepository.findById(id);
        if (partenaire.isPresent()) {
            Partenaire updatedPartenaire = partenaire.get();
            updatedPartenaire.setStatus(statut);
            return partenaireRepository.save(updatedPartenaire);
        } else {
            throw new IllegalArgumentException("Partenaire introuvable.");
        }
    }

    @Override
    public Optional<Partenaire> getPartenaireById(Long id) {
        return partenaireRepository.findById(id);
    }

    @Override
    public List<Partenaire> listerPartenaires() {
        return partenaireRepository.findAll();
    }

    public Long countAllPartenaires() {
        return partenaireRepository.count();
    }
}
