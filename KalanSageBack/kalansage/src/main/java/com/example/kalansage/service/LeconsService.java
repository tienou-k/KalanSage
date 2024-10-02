package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;

import java.util.List;
import java.util.Optional;

public interface LeconsService {

    Lecons modifierLecon(Lecons lecons);

    Lecons creerLecon(Lecons lecons);

    void supprimerLecon(Long idLecon);

    Optional<Lecons> getLecons(Long idLecon);

    List<Lecons> listerLecons();

    Optional<Lecons> getLeconById(Long LeconId);
}