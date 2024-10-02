package com.example.kalansage.service;

import com.example.kalansage.model.Commentaire;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.CommentaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentaireServiceImpl implements CommentaireService {

    @Autowired
    private CommentaireRepository commentaireRepository;


    @Override
    public List<Commentaire> getAllCommentaires() {
        return null;
    }

    @Override
    public Commentaire createCommentaire(Commentaire commentaire) {
        return null;
    }

    @Override
    public void supprimerCommentaire(Long id) {

    }

    @Override
    public Object modifierCommentaire(Module modules) {
        return null;
    }
}
