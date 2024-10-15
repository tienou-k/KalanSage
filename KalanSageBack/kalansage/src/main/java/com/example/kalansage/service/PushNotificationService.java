package com.example.kalansage.service;


import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.stereotype.Service;

@Service
public class PushNotificationService {

    public void sendOtpNotification(String deviceToken, String otp) {
        try {
            // Create the notification message
            Notification notification = Notification.builder()
                    .setTitle("Votre code OTP ")
                    .setBody("Votre OTP code est: " + otp + ". Ce code est valid pour 10 minutes.")
                    .build();

            // Build the message with the device token and notification
            Message message = Message.builder()
                    .setToken(deviceToken)
                    .setNotification(notification)
                    .build();

            // Send the message to Firebase
            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
