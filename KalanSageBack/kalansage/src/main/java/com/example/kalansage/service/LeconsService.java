package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;

import java.util.List;

public interface LeconsService {

    Lecons modifierLecon(Lecons lecons);
    Lecons creerLecon(Lecons lecons);
    void supprimerLecon(Long id);
    Lecons getLeconById(Long id);
    List<Lecons> findByModule_Id(Long moduleId);
    List<Lecons> listerLecons();
    Long countByModule_Id(Long moduleId);
}