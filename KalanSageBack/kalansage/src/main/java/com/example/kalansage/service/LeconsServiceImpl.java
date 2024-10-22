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
    @Autowired
    private FilesStorageServiceImpl filesStorageService;

    public LeconsServiceImpl(LeconsRepository leconsRepository) {
        this.leconsRepository = leconsRepository;
    }


    // Method to save the video
    @Override
    public Lecons creerLecon(Lecons lecon) {
        // Check if a module with the same title already exists
        if (leconsRepository.existsByTitreAndDescriptionAndContenu(lecon.getTitre(), lecon.getContenu(), lecon.getDescription())) {
            throw new RuntimeException("Une Lecon avec le même"+ lecon.getTitre() +"existe déjà.");
        }
        lecon.setTitre(lecon.getTitre().trim());
        lecon.setDescription(lecon.getDescription());
        lecon.setContenu(lecon.getContenu());
        if (lecon.getModule() != null) {
            Module module = moduleRepository.findModuleByTitre(lecon.getModule().getTitre())
                    .orElseThrow(() -> new RuntimeException("Module n'existe pas !"));
            lecon.setModule(module);
        } else {
            throw new RuntimeException("Module non spécifiée !");
        }
        return leconsRepository.save(lecon);
    }

    public boolean leconExiste(String titre, String description, String contenu) {
        return leconsRepository.existsByTitreAndDescriptionAndContenu(titre, description, contenu);
    }


    @Override
    public Lecons modifierLecon(Lecons lecon) {
        // Check if the lesson exists before updating (can be done in the controller as well)
        Optional<Lecons> existingLecon = leconsRepository.findById(lecon.getIdLecon());
        if (existingLecon.isPresent()) {
            return leconsRepository.save(lecon);  // Save the updated lesson
        } else {
            throw new EntityNotFoundException("Leçon avec ID " + lecon.getIdLecon() + " n'existe pas.");
        }
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
