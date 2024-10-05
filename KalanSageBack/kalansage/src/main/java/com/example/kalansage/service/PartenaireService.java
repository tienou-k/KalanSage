package com.example.kalansage.service;


import com.example.kalansage.model.Partenaire;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

public interface PartenaireService {
    Partenaire creerPartenariat(Partenaire partenaire, MultipartFile logoFile) throws IOException;

    Partenaire modifierPartenariat(Long id, Partenaire partenaire);

    void supprimerPartenariat(Long id);

    Partenaire activerDesactiverPartenariat(Long id, boolean statut);

    Optional<Partenaire> getPartenaireById(Long id);

    List<Partenaire> listerPartenaires();
}
