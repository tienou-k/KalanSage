package com.example.kalansage.service;

import com.example.kalansage.model.Badge;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserBadge;
import com.example.kalansage.repository.BadgeRepository;
import com.example.kalansage.repository.UserBadgeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class BadgeService {
    @Autowired
    private BadgeRepository badgeRepository;
    @Autowired
    private UserService userService;

    @Autowired
    private UserPointsService userPointsService;
    @Autowired
    private UserBadgeRepository userBadgeRepository;

    public UserBadge awardBadge(Long userId, Long badgeId) {
        User user = userService.getUserById(userId);
        Badge badge = badgeRepository.findById(badgeId).orElseThrow(() -> new RuntimeException("Badge not found"));

        if (user.getUserPoints().getTotalPoints() >= badge.getSeuilDePoints()) {
            UserBadge userBadge = new UserBadge();
            userBadge.setUser(user);
            userBadge.setBadge(badge);
            userBadge.setDateEarned(new Date());

            return userBadgeRepository.save(userBadge);
        } else {
            throw new RuntimeException("User has not earned enough points for this badge.");
        }
    }
}
