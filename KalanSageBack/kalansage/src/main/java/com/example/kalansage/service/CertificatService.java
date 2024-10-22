package com.example.kalansage.service;

import com.example.kalansage.model.Certificat;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.CertificatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class CertificatService {
    @Autowired
    private CertificatRepository certificatRepository;

    @Autowired
    private ModuleServiceImpl moduleService;

    @Autowired
    private UserService userService;
    @Autowired
    private TestService testService;

    public Certificat issueCertificate(Long id, Long moduleId) {
        User user = userService.getUser(id);
        Module modules = moduleService.getModuleModel(moduleId);

        // Check if user has passed the course's test
        if (!testService.hasPassedTest(user, modules)) {
            throw new RuntimeException("L'utilisateur n'a pas réussi le test du cours.");
        }

        Certificat certificat = new Certificat();
        certificat.setUser(user);
        certificat.setModules(modules);
        certificat.setDateObtention(new Date());

        return certificatRepository.save(certificat);
    }

}
