package com.example.kalansage.controller;



import com.example.kalansage.dto.UserBookmarkDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBookmark;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.UserRepository;
import com.example.kalansage.service.ModuleService;
import com.example.kalansage.service.UserBookmarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;



@RestController
@RequestMapping("/api/bookmarks")
public class UserBookmarkController {

    @Autowired
    private UserBookmarkService userBookmarkService;
    @Autowired
    private ModuleRepository moduleRepository;
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ModuleService moduleService;

    // Add a bookmark
    @PostMapping("/add/{moduleId}")
    public UserBookmarkDTO addBookmark(@PathVariable Long moduleId, @RequestParam Long id) {
        User user = userRepository.findUserById(id);
        Module module = moduleService.getModuleById(moduleId);
        // Check if the bookmark already exists
        if (userBookmarkService.bookmarkExists(user.getId(), module.getId())) {
            throw new RuntimeException("This module is already bookmarked by the user."); // Or create a custom exception
        }
        UserBookmark userBookmark = userBookmarkService.addBookmark(user.getId(), module.getId());
        return new UserBookmarkDTO(userBookmark.getId(), user.getId(), module.getId(), userBookmark.getBookmarkDate());
    }


    // Remove a bookmark
    @DeleteMapping("/remove/{moduleId}")
    public void removeBookmark(@PathVariable Long moduleId, @RequestParam Long id) {
        User user = userRepository.findUserById(id);
        Module module = moduleService.getModuleById(moduleId);
        userBookmarkService.removeBookmark(user, module);
    }

    // Check if a module is bookmarked
    @GetMapping("/isBookmarked/{moduleId}")
    public boolean isBookmarked(@PathVariable Long moduleId, @RequestParam Long id) {
        User user = userRepository.findUserById(id);
        Module module = moduleService.getModuleById(moduleId);
        return userBookmarkService.isBookmarked(user, module);
    }
}
