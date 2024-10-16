package com.example.kalansage.service;



import com.example.kalansage.model.OTP;
import com.example.kalansage.model.User;
import com.example.kalansage.repository.OTPRepository;
import com.example.kalansage.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class OTPService {

    @Autowired
    private OTPRepository otpRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PushNotificationService pushNotificationService;
    @Autowired
    private FirebaseService firebaseService;

    // Generate a random OTP
    public String generateOTP(int length) {
        Random random = new Random();
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }

    // Create and send OTP via Firebase push notification
    public void createAndSendOTP(String email, String deviceToken) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        if (userOptional.isPresent()) {
            User user = userOptional.get();

            String otp = generateOTP(5);
            OTP otpEntity = new OTP();
            otpEntity.setUser(user);
            otpEntity.setOtp(otp);
            otpEntity.setOtpExpiry(LocalDateTime.now().plusMinutes(10));

            otpRepository.save(otpEntity);

            // Send OTP via push notification
            firebaseService.sendPushNotification(deviceToken, "Your OTP", otp);
        }
    }

    // Verify OTP
    public boolean verifyOTP(String email, String otp) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            Optional<OTP> otpOptional = otpRepository.findByUserIdAndOtp(user.getId(), otp);

            if (otpOptional.isPresent()) {
                OTP otpEntity = otpOptional.get();
                // Check if OTP is still valid (not expired)
                if (otpEntity.getOtpExpiry().isAfter(LocalDateTime.now())) {
                    user.setStatus(true);
                    userRepository.save(user);
                    otpRepository.delete(otpEntity);
                    return true;
                }
            }
        }
        return false;
    }
}