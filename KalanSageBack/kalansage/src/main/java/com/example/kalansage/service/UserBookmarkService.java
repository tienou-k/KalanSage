package com.example.kalansage.service;


import com.example.kalansage.model.userAction.UserBookmark;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.UserBookmarkRepository;
import com.example.kalansage.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
public class UserBookmarkService {

    @Autowired
    private UserBookmarkRepository userBookmarkRepository;
    @Autowired
    private  UserRepository userRepository;
    @Autowired
    private ModuleRepository moduleRepository;

    // Add a bookmark
    public UserBookmark addBookmark(Long userId, Long moduleId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));

        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new EntityNotFoundException("Module not found"));

        UserBookmark bookmark = new UserBookmark();
        bookmark.setUser(user);
        bookmark.setModule(module);
        bookmark.setBookmarkDate(new Date());

        return userBookmarkRepository.save(bookmark);
    }


    // Remove a bookmark
    public void removeBookmark(User user, Module module) {
        userBookmarkRepository.deleteByUserAndModule(user, module);
    }

    // Check if a module is bookmarked by a user
    public boolean isBookmarked(User user, Module module) {
        return userBookmarkRepository.findByUserAndModule(user, module).isPresent();
    }

    public boolean bookmarkExists(Long userId, Long moduleId) {
        return userBookmarkRepository.existsByUserIdAndModuleId(userId, moduleId);
    }

}
