package com.example.kalansage.service;

import com.example.kalansage.model.Commentaire;
import com.example.kalansage.model.Module;

import java.util.List;

public interface CommentaireService {
    List<Commentaire> getAllCommentaires();

    Commentaire createCommentaire(Commentaire commentaire);

    void supprimerCommentaire(Long id);

    Object modifierCommentaire(Module modules);
}
