package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.repository.LeconsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LeconsServiceImpl implements LeconsService {

    @Autowired
    private LeconsRepository leconsRepository;

    public LeconsServiceImpl(LeconsRepository leconsRepository) {
        this.leconsRepository = leconsRepository;
    }


    @Override
    public Lecons creerLecon(Lecons lecons) {
        return leconsRepository.save(lecons);
    }

    @Override
    public Lecons modifierLecon(Long id, Lecons leconsDetails) {
        Lecons lecons = getLeconById(id);
        lecons.setTitre(leconsDetails.getTitre());
        lecons.setDescription(leconsDetails.getDescription());
        lecons.setContenu(leconsDetails.getContenu());
        lecons.setModule(leconsDetails.getModule());
        return leconsRepository.save(lecons);
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
    public List<Lecons> listerLecons() {
        return leconsRepository.findAll();
    }


}
