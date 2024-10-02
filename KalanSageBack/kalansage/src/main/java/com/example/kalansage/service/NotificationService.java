package com.example.kalansage.service;

import com.example.kalansage.model.Notification;

import java.util.List;
import java.util.Optional;

public interface NotificationService {
    Notification saveNotification(Notification notification);
    Optional<Notification> getNotificationById(Long id);
    List<Notification> getAllNotifications();
    Notification updateNotification(Long id, Notification notification);
    void deleteNotification(Long id);
}
