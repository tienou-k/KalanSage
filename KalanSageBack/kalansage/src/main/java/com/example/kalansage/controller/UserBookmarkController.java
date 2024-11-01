package com.example.kalansage.controller;

import com.example.kalansage.dto.UserBookmarkDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBookmark;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.UserRepository;
import com.example.kalansage.service.ModuleService;
import com.example.kalansage.service.UserBookmarkService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookmarks")
public class UserBookmarkController {

    @Autowired
    private UserBookmarkService userBookmarkService;

    @Autowired
    private ModuleService moduleService;

    @Autowired
    private UserRepository userRepository;

    // Add a bookmark
    @PostMapping("/add/{userId}/{moduleId}")
    public ResponseEntity<UserBookmarkDTO> addBookmark(@PathVariable Long userId, @PathVariable Long moduleId) {
        UserBookmarkDTO dto = userBookmarkService.addBookmark(userId, moduleId);
        return ResponseEntity.ok(dto);
    }

    // Retrieve bookmarked modules for a user
    @GetMapping("/bookmarked-modules/{userId}")
    public ResponseEntity<List<UserBookmarkDTO>> getBookmarkedModules(@PathVariable Long userId) {
        List<UserBookmarkDTO> dtoList = userBookmarkService.getBookmarkedModules(userId);
        return ResponseEntity.ok(dtoList);
    }

    // Remove a bookmark
    @DeleteMapping("/remove/{userId}/{moduleId}")
    public ResponseEntity<String> removeBookmark(@PathVariable Long userId, @PathVariable Long moduleId) {
        String responseMessage = userBookmarkService.removeBookmark(userId, moduleId);
        return ResponseEntity.ok(responseMessage);
    }

    // Check if a module is bookmarked
    @GetMapping("/isBookmarked/{userId}/{moduleId}")
    public ResponseEntity<Map<String, String>> isBookmarked(@PathVariable Long userId, @PathVariable Long moduleId) {
        Map<String, String> response = userBookmarkService.isBookmarked(userId, moduleId);
        return ResponseEntity.ok(response);
    }
}
