package com.example.kalansage.repository;

import com.example.kalansage.model.Categorie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface CategorieRepository extends JpaRepository<Categorie, Long> {
    Optional<Categorie> findByNomCategorie(String nomCategorie);

    Optional<Categorie> findCategorieByIdCategorie(Long i);

    boolean existsByNomCategorie(String nomCategorie);
}
