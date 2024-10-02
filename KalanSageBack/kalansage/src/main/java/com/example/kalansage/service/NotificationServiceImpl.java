package com.example.kalansage.service;

import com.example.kalansage.model.Notification;
import com.example.kalansage.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Override
    public Notification saveNotification(Notification paiement) {
        return notificationRepository.save(paiement);
    }

    @Override
    public Optional<Notification> getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    @Override
    public List<Notification> getAllNotifications() {
        return notificationRepository.findAll();
    }

    @Override
    public Notification updateNotification(Long id, Notification notification) {

        return notificationRepository.save(notification);

    }

    @Override
    public void deleteNotification(Long id) {
        notificationRepository.deleteById(id);
    }
}