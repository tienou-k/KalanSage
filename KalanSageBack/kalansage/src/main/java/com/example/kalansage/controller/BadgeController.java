package com.example.kalansage.controller;

import com.example.kalansage.model.userAction.UserBadge;
import com.example.kalansage.service.BadgeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/badges")
public class BadgeController {
    @Autowired
    private BadgeService badgeService;


    @PostMapping("/gagner/badges")
    public ResponseEntity<UserBadge> awardBadge(@RequestParam Long userId, @RequestParam Long badgeId) {
        return ResponseEntity.ok(badgeService.awardBadge(userId, badgeId));
    }
}
