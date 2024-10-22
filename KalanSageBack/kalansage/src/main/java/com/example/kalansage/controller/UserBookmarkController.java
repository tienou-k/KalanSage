package com.example.kalansage.controller;



import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBookmark;
import com.example.kalansage.service.ModuleService;
import com.example.kalansage.service.UserBookmarkService;
import com.example.kalansage.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bookmarks")
public class UserBookmarkController {

    @Autowired
    private UserBookmarkService userBookmarkService;

    @Autowired
    private UserService userService;

    @Autowired
    private ModuleService moduleService;

    // Add a bookmark
    @PostMapping("/add/{moduleId}")
    public UserBookmark addBookmark(@PathVariable Long moduleId, @RequestParam Long userId) {
        User user = userService.getUserById(userId); // assume this exists
        Module module = moduleService.getModuleById(moduleId); // assume this exists
        return userBookmarkService.addBookmark(user, module);
    }

    // Remove a bookmark
    @DeleteMapping("/remove/{moduleId}")
    public void removeBookmark(@PathVariable Long moduleId, @RequestParam Long userId) {
        User user = userService.getUserById(userId);
        Module module = moduleService.getModuleById(moduleId);
        userBookmarkService.removeBookmark(user, module);
    }

    // Check if a module is bookmarked
    @GetMapping("/isBookmarked/{moduleId}")
    public boolean isBookmarked(@PathVariable Long moduleId, @RequestParam Long userId) {
        User user = userService.getUserById(userId);
        Module module = moduleService.getModuleById(moduleId);
        return userBookmarkService.isBookmarked(user, module);
    }
}
