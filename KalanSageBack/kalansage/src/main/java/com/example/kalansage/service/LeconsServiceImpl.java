package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.LeconsRepository;
import com.example.kalansage.repository.ModuleRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LeconsServiceImpl implements LeconsService {

    @Autowired
    private LeconsRepository leconsRepository;
    @Autowired
    private ModuleRepository moduleRepository;

    public LeconsServiceImpl(LeconsRepository leconsRepository) {
        this.leconsRepository = leconsRepository;
    }


    public Lecons creerLecon(Lecons lecon) {
        Module module = moduleRepository.findById(lecon.getModule().getId())
                .orElseThrow(() -> new EntityNotFoundException("Module not found"));
        lecon.setModule(module);
        return leconsRepository.save(lecon);
    }


    public boolean leconExiste(String titre, String description, String contenu) {
        return leconsRepository.existsByTitreAndDescriptionAndContenu(titre, description, contenu);
    }


    public Lecons modifierLecon(Long leconId, Lecons updatedLecon) {
        return leconsRepository.findById(leconId)
                .map(lecon -> {
                    lecon.setTitre(updatedLecon.getTitre());
                    lecon.setDescription(updatedLecon.getDescription());
                    lecon.setContenu(updatedLecon.getContenu());
                    return leconsRepository.save(lecon);
                })
                .orElseThrow(() -> new RuntimeException("Leçon non trouvée"));
    }


    @Override
    public void supprimerLecon(Long id) {
        Lecons lecons = getLeconById(id);
        leconsRepository.delete(lecons);
    }

    @Override
    public Lecons getLeconById(Long id) {
        Optional<Lecons> lecon = leconsRepository.findById(id);
        return lecon.orElseThrow(() -> new RuntimeException("Leçon non trouvée avec l'id: " + id));
    }

    @Override
    public List<Lecons> findByModule_Id(Long moduleId) {
        return leconsRepository.findByModule_Id(moduleId);
    }

    @Override
    public Long countByModule_Id(Long moduleId) {
        // Count lessons based on the moduleId
        return leconsRepository.countByModule_Id(moduleId);
    }

    @Override
    public List<Lecons> listerLecons() {
        return leconsRepository.findAll();
    }


}
