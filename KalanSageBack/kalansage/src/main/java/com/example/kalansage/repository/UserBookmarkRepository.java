package com.example.kalansage.repository;


import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBookmark;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserBookmarkRepository extends JpaRepository<UserBookmark, Long> {
    Optional<UserBookmark> findByUserAndModule(User user, Module module);
    void deleteByUserAndModule(User user, Module module);

    boolean existsByModuleIdAndUserId(Long moduleId, Long userId);

    boolean existsByUserIdAndModuleId(Long userId, Long moduleId);

    List<UserBookmark> findAllByUserId(Long id);
}
