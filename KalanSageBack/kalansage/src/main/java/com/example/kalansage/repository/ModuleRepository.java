package com.example.kalansage.repository;

import com.example.kalansage.model.Categorie;
import com.example.kalansage.model.Module;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ModuleRepository extends JpaRepository<Module, Long> {
    List<Module> findByCategorie(Categorie categorie);
    boolean existsByTitre(String titre);
    Optional<Module> findModuleByTitre(String titreModule);
    @Query("SELECT m FROM Module m LEFT JOIN UserModule um ON m.id = um.module.id GROUP BY m ORDER BY COUNT(um.id) DESC")
    List<Module> findTopModules(Pageable pageable);
    List<Module> findByCategorie_IdCategorie(Long idCategorie);

    Module findModuleById(Long id);
}
