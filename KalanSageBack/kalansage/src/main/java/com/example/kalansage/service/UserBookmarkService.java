package com.example.kalansage.service;

import com.example.kalansage.dto.UserBookmarkDTO;
import com.example.kalansage.model.userAction.UserBookmark;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.UserBookmarkRepository;
import com.example.kalansage.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UserBookmarkService {

    @Autowired
    private UserBookmarkRepository userBookmarkRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ModuleRepository moduleRepository;

    // Add a bookmark
    public UserBookmarkDTO addBookmark(Long userId, Long moduleId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));

        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new EntityNotFoundException("Module not found"));

        // Check if the bookmark already exists
        if (bookmarkExists(userId, moduleId)) {
            throw new RuntimeException("Bookmark already exists");
        }

        UserBookmark bookmark = new UserBookmark();
        bookmark.setUser(user);
        bookmark.setModule(module);
        bookmark.setBookmarkDate(new Date());

        userBookmarkRepository.save(bookmark);
        return new UserBookmarkDTO(
                bookmark.getId(),
                user.getId(),
                module.getId(),
                module.getTitre(),
                module.getDescription(),
                module.getPrix(),
                module.getImageUrl(),
                bookmark.getBookmarkDate()
        );
    }

    // Remove a bookmark
    @Transactional
    public String removeBookmark(Long userId, Long moduleId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));

        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new EntityNotFoundException("Module not found"));

        UserBookmark bookmark = userBookmarkRepository.findByUserAndModule(user, module)
                .orElseThrow(() -> new RuntimeException("Bookmark not found"));

        userBookmarkRepository.delete(bookmark);

        return "Bookmark removed for module ID " + moduleId + " by user ID " + userId + ".";
    }

    // Check if a module is bookmarked by a user
    public Map<String, String> isBookmarked(Long userId, Long moduleId) {
        boolean bookmarked = bookmarkExists(userId, moduleId);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Module ID " + moduleId + (bookmarked ? " is" : " is not") + " bookmarked by user ID " + userId + ".");
        return response;
    }

    public boolean bookmarkExists(Long userId, Long moduleId) {
        return userBookmarkRepository.existsByUserIdAndModuleId(userId, moduleId);
    }

    // Get bookmarks by user ID
    public List<UserBookmarkDTO> getBookmarkedModules(Long userId) {
        List<UserBookmark> bookmarks = userBookmarkRepository.findAllByUserId(userId);
        List<UserBookmarkDTO> dtoList = new ArrayList<>();

        for (UserBookmark bookmark : bookmarks) {
            dtoList.add(new UserBookmarkDTO(
                    bookmark.getId(),
                    bookmark.getUser().getId(),
                    bookmark.getModule().getId(),
                    bookmark.getModule().getTitre(),
                    bookmark.getModule().getDescription(),
                    bookmark.getModule().getPrix(),
                    bookmark.getModule().getImageUrl(),
                    bookmark.getBookmarkDate()));
        }

        return dtoList;
    }
}
