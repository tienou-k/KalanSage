package com.example.kalansage.service;

import com.example.kalansage.model.Forum;

import java.util.List;
import java.util.Optional;

public interface ForumService {
    Forum createForum(Forum forum);
    Optional<Forum> getForumById(Long id);
    List<Forum> getAllForums();
    Forum updateForum(Long id, Forum forum);
    void deleteForum(Long id);
}
