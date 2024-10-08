package com.example.kalansage.service;


import com.example.kalansage.dto.AbonnementDTO;
import com.example.kalansage.model.Abonnement;
import com.example.kalansage.repository.AbonnementRepository;
import com.example.kalansage.repository.UserRepository;
import com.example.kalansage.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AbonnementServiceImpl implements AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private UtilisateurRepository utilisateurRepository;
    @Autowired
    private UserRepository userRepository;

    @Override
    public Abonnement creerAbonnement(AbonnementDTO abonnementDTO) {

        if (abonnementRepository.existsByTypeAbonnement(abonnementDTO.getTypeAbonnement())) {
            throw new RuntimeException("Cet Abonnement exist déjà. Veillez réeassyer un autre type !");
        }
        Abonnement abonnement = new Abonnement();
        abonnement.setTypeAbonnement(abonnementDTO.getTypeAbonnement());
        abonnement.setDescription(abonnementDTO.getDescription());
        abonnement.setPrix(abonnementDTO.getPrix());
        abonnement.setDateExpiration(abonnementDTO.getDateExpiration());
        abonnement.setStatut(abonnementDTO.getStatut());

        return abonnementRepository.save(abonnement);
    }

    @Override
    public Abonnement modifierAbonnement(Long id, Abonnement updatedAbonnement) {
        Abonnement existingAbonnement = abonnementRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Abonnement non rétrouvé"));

        existingAbonnement.setTypeAbonnement(updatedAbonnement.getTypeAbonnement());
        existingAbonnement.setStatut(updatedAbonnement.getStatut());
        existingAbonnement.setDateExpiration(updatedAbonnement.getDateExpiration());
        existingAbonnement.setPrix(updatedAbonnement.getPrix());
        existingAbonnement.setDescription(updatedAbonnement.getDescription());
        return abonnementRepository.save(existingAbonnement);
    }

    @Override
    public void supprimerAbonnement(Long idAbonnement) {
        Optional<Abonnement> abonnementOptional = abonnementRepository.findById(idAbonnement);
        if (abonnementOptional.isPresent()) {
            abonnementRepository.delete(abonnementOptional.get());
        } else {
            throw new IllegalArgumentException("Abonnement introuvable avec l'ID : " + idAbonnement);
        }
        if (abonnementOptional.isPresent()) {
            System.out.println("Abonnement supprimer avec succès");
        } else {
            System.out.println("Abonnement non trouvé avec l'ID : " + idAbonnement);
        }
    }

    @Override
    public Optional<Abonnement> getAbonnement(Long idAbonnement) {
        return abonnementRepository.findById(idAbonnement);
    }

    public List<Abonnement> getAbonnement(boolean statutAbonnement) {
        return abonnementRepository.findByStatut(statutAbonnement);
    }

    @Override
    public List<Abonnement> listerAbonnements() {
        return abonnementRepository.findAll();
    }

    @Override
    public void annulerAbonnement(Long idAbonnement) {
        abonnementRepository.deleteById(idAbonnement);
    }

    @Override
    public Abonnement validerAbonnement(Long idAbonnement) {
        // Implement logic to validate the subscription
        return abonnementRepository.findById(idAbonnement).orElse(null);
    }


}