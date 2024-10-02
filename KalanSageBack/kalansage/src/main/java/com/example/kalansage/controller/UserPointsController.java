package com.example.kalansage.controller;

import com.example.kalansage.service.UserPointsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/points")
public class UserPointsController {
    @Autowired
    private UserPointsService userPointsService;

    @PostMapping("/gagner/points")
    public ResponseEntity<String> awardPoints(@RequestParam Long userId, @RequestParam int points) {
        userPointsService.awardPoints(userId, points);
        return ResponseEntity.ok("Points awarded successfully.");
    }
}
