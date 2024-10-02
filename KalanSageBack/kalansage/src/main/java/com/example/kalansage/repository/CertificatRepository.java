package com.example.kalansage.repository;

import com.example.kalansage.model.Certificat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CertificatRepository extends JpaRepository<Certificat, Long> {

}
