package com.example.kalansage.service;

import com.example.kalansage.dto.CategorieDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import com.example.kalansage.repository.CategorieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

<<<<<<< HEAD
=======
import java.util.ArrayList;
>>>>>>> 6044997 (repusher)
import java.util.List;


@Service
public class CategorieServiceImpl implements CategorieService {

    @Autowired
    private CategorieRepository categorieRepository;

    @Override
    public Categorie creerCategorie(CategorieDTO categorieDTO) {
        if (categorieRepository.existsByNomCategorie(categorieDTO.getNomCategorie())) {
            throw new RuntimeException("Une Categorie avec le même nom exist déjà !");
        }
        Categorie categorie = new Categorie();
        categorie.setNomCategorie(categorieDTO.getNomCategorie());
        categorie.setDescription(categorieDTO.getDescription());
        return categorieRepository.save(categorie);
    }

    // modifier de la catégorie
    @Override
    public Categorie modifierCategorie(Long id, Categorie updatedCategorie) {
        Categorie existingCategorie = categorieRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categorie non rétrouvée"));

        existingCategorie.setNomCategorie(updatedCategorie.getNomCategorie());
        existingCategorie.setDescription(updatedCategorie.getDescription());
        return categorieRepository.save(existingCategorie);
    }

    //--------------------------supprimer la categorie--------------------------------------
    @Override
    public void supprimerCategorie(Long idCategorie) {
        categorieRepository.deleteById(idCategorie);
    }

    //--------------------------lister toutes les categories--------------------------------------
    @Override
    public List<Categorie> getAllCategories() {
        return categorieRepository.findAll();
    }

    //--------------------------get categorie par id--------------------------------------
    @Override
    public Categorie getCategoriebyId(Long idCategorie) {
        return categorieRepository.findById(idCategorie).orElse(null);
    }

    //------------------------la listes des cours dans une categorie--------------------------------
    @Override
<<<<<<< HEAD
    public List<Module> getCoursesInCategorie(Long categorieId) {
        return categorieRepository.findById(categorieId).map(Categorie::getModules).orElse(null);
=======
    public List<Module> getModulesListInCategorie(Long categorieId) {
        return categorieRepository.findById(categorieId)
                .map(Categorie::getModules)
                .orElse(new ArrayList<>());
    }

    @Override
    public int getModulesCountInCategorie(Long categorieId) {
        return categorieRepository.findById(categorieId)
                .map(categorie -> categorie.getModules().size())
                .orElse(0);
>>>>>>> 6044997 (repusher)
    }

    @Override
    public void removeCourseFromCategorie(Long categorieId, Long courseId) {
        // methode pour enlever un cours de la categorie
        categorieRepository.findById(categorieId)
                .ifPresent(categorie -> categorie.getModules().removeIf(cours -> cours.getId().equals(courseId)));
    }
<<<<<<< HEAD
=======


>>>>>>> 6044997 (repusher)
}
