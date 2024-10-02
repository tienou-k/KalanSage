package com.example.kalansage.controller;


import com.example.kalansage.model.Forum;
import com.example.kalansage.service.ForumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/forum")
public class ForumController {

    @Autowired
    private ForumService forumService;

    @GetMapping
    public ResponseEntity<List<Forum>> getAllForums() {
        List<Forum> forums = forumService.getAllForums();
        return ResponseEntity.ok(forums);
    }

    @PostMapping
    public ResponseEntity<Forum> createForum(@RequestBody Forum forum) {
        Forum newForum = forumService.createForum(forum);
        return ResponseEntity.status(HttpStatus.CREATED).body(newForum);
    }
}

