package com.example.kalansage.service;

import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.UserPoints;
import com.example.kalansage.repository.UserPointsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserPointsService {
    @Autowired
    private UserPointsRepository userPointsRepository;

    @Autowired
    private UserService userService;

    public void awardPoints(Long userId, int points) {
        User user = userService.getUser(userId);
        UserPoints userPoints = user.getUserPoints();

        if (userPoints == null) {
            userPoints = new UserPoints();
            userPoints.setUser(user);
            userPoints.setTotalPoints(0);
        }

        userPoints.setTotalPoints(userPoints.getTotalPoints() + points);
        userPointsRepository.save(userPoints);
    }
}
