package com.example.kalansage.controller;


import com.example.kalansage.model.Commentaire;
import com.example.kalansage.model.Module;
import com.example.kalansage.service.CommentaireService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/commentaires")
public class CommentaireController {

    @Autowired
    private CommentaireService commentaireService;

    @GetMapping("/list-commentaires")
    public ResponseEntity<List<Commentaire>> getAllCommentaires() {
        List<Commentaire> commentaires = commentaireService.getAllCommentaires();
        return ResponseEntity.ok(commentaires);
    }

    @PostMapping("/creer-commentaires")
    public ResponseEntity<Commentaire> createCommentaire(@RequestBody Commentaire commentaire) {
        Commentaire newCommentaire = commentaireService.createCommentaire(commentaire);
        return ResponseEntity.status(HttpStatus.CREATED).body(newCommentaire);
    }

    @PutMapping("/modifier-cour/{id}")
    public ResponseEntity<Module> modifierCours(@PathVariable Long id, @RequestBody Module modules) {
        modules.setId(id);
        return ResponseEntity.ok((Module) commentaireService.modifierCommentaire(modules));
    }

    @DeleteMapping("/supprimer-commentaire/{id}")
    public ResponseEntity<Void> supprimerCommentaire(@PathVariable Long id) {
        commentaireService.supprimerCommentaire(id);
        return ResponseEntity.noContent().build();
    }
}

