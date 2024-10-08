package com.example.kalansage.repository;

import com.example.kalansage.model.Lecons;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LeconsRepository extends JpaRepository<Lecons, Long> {

    List<Lecons> findByModule_Id(Long moduleId);
}
