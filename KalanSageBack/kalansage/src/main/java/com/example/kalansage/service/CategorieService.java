package com.example.kalansage.service;

import com.example.kalansage.dto.CategorieDTO;
import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;

import java.util.List;

public interface CategorieService {

    List<Module> getModulesListInCategorie(Long categorieId);

    void removeCourseFromCategorie(Long categorieId, Long courseId);

    Categorie creerCategorie(CategorieDTO categorie);

    // modifier de la catégorie
    Categorie modifierCategorie(Long id, Categorie updatedCategorie);

    //--------------------------supprimer la categorie--------------------------------------
    void supprimerCategorie(Long idCategorie);

    //--------------------------lister toutes les categories--------------------------------------
    List<Categorie> getAllCategories();


    //--------------------------get categorie par id--------------------------------------
    Categorie getCategoriebyId(Long idCategorie);

    int getModulesCountInCategorie(Long categorieId);
}
