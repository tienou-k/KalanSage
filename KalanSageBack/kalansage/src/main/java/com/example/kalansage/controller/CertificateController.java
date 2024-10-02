package com.example.kalansage.controller;

import com.example.kalansage.model.Certificat;
import com.example.kalansage.service.CertificatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admins/certificats")
public class CertificateController {
    @Autowired
    private CertificatService certificatService;

    @PostMapping("/issue")
    public ResponseEntity<Certificat> issueCertificate(@RequestParam Long userId, @RequestParam Long courseId) {
        return ResponseEntity.ok(certificatService.issueCertificate(userId, courseId));
    }
}
