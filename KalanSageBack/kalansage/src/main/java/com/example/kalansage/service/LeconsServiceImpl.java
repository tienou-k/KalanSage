package com.example.kalansage.service;

import com.example.kalansage.model.Lecons;
import com.example.kalansage.repository.LeconsRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LeconsServiceImpl implements LeconsService {


    private final LeconsRepository leconsRepository;

    public LeconsServiceImpl(LeconsRepository leconsRepository) {
        this.leconsRepository = leconsRepository;
    }

    @Override
    public Lecons modifierLecon(Lecons lecons) {
        return leconsRepository.save(lecons);
    }

    @Override
    public Lecons creerLecon(Lecons lecons) {
        return leconsRepository.save(lecons);
    }

    @Override
    public void supprimerLecon(Long idlecon) {
        leconsRepository.deleteById(idlecon);
    }

    @Override
    public Optional<Lecons> getLecons(Long idlecon) {
        return leconsRepository.findById(idlecon);
    }

    @Override
    public List<Lecons> listerLecons() {
        return leconsRepository.findAll();
    }

    @Override
    public Optional<Lecons> getLeconById(Long leconId) {
        return leconsRepository.findById(leconId);
    }


}
