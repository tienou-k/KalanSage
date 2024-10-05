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

    List<Module> findCoursByPrix(float prix);

    boolean existsByTitre(String titre);

    Optional<Module> findModuleByTitre(String titreModule);

    @Query("SELECT m FROM Module m LEFT JOIN UserModule um ON m.idModule = um.modules.id GROUP BY m ORDER BY COUNT(um.id) DESC")
    List<Module> findTopModules(Pageable pageable);
}
