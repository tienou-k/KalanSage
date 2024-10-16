package com.example.kalansage.repository;

import org.springframework.stereotype.Repository;

import java.util.HashSet;
import java.util.Set;

@Repository
public interface TokenBlacklistRepository {
    Set<String> blacklistedTokens = new HashSet<>();

    public default void addToken(String token) {
        blacklistedTokens.add(token);
    }

    public default boolean isTokenBlacklisted(String token) {
        return blacklistedTokens.contains(token);
    }

}
