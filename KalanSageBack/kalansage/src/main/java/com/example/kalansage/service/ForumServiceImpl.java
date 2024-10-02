package com.example.kalansage.service;

import com.example.kalansage.model.Forum;
import com.example.kalansage.repository.ForumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ForumServiceImpl implements ForumService{
    @Autowired
    private ForumRepository forumRepository;

    @Override
    public Forum createForum(Forum forum) {
        return forumRepository.save(forum);
    }

    @Override
    public Optional<Forum> getForumById(Long id) {
        return forumRepository.findById(id);
    }

    @Override
    public List<Forum> getAllForums() {
        return forumRepository.findAll();
    }

    @Override
    public Forum updateForum(Long id, Forum forum) {
        Optional<Forum> existingForum = forumRepository.findById(id);
        if (existingForum.isPresent()) {
            Forum updatedForum = existingForum.get();
            updatedForum.setTitle(forum.getTitle());
            updatedForum.setDescription(forum.getDescription());
            updatedForum.setCreatedAt(forum.getCreatedAt());
            return forumRepository.save(updatedForum);
        }
        return null;
    }

    @Override
    public void deleteForum(Long id) {
        forumRepository.deleteById(id);
    }
}