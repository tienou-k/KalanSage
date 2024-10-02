package com.example.kalansage.repository;

import com.example.kalansage.model.Lecons;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentaireRepository extends JpaRepository<Lecons, Long> {


}
