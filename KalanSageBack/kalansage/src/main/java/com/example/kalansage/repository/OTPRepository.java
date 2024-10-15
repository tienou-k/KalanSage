package com.example.kalansage.repository;


import com.example.kalansage.model.OTP;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OTPRepository extends JpaRepository<OTP, Long> {
    Optional<OTP> findByUserIdAndOtp(Long userId, String otp);
}
