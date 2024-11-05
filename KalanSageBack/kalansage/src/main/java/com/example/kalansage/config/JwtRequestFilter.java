package com.example.kalansage.config;



import com.example.kalansage.repository.TokenBlacklistRepository;
import com.example.kalansage.service.CustomUserDetailsService;
import com.example.kalansage.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private TokenBlacklistRepository tokenBlacklistRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        // List of public endpoints that should bypass JWT processing
        String requestURI = request.getRequestURI();
        if (isPublicEndpoint(requestURI)) {
            chain.doFilter(request, response);
            return;
        }

        final String authorizationHeader = request.getHeader("Authorization");
        String username = null;
        String jwt = null;

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7);
            try {
                // Check if the token is blacklisted
                if (tokenBlacklistRepository.isTokenBlacklisted(jwt)) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token is blacklisted");
                    return;
                }

                username = jwtUtil.extractUsername(jwt);
            } catch (Exception e) {
                logger.error("JWT parsing error: " + e.getMessage());
            }
        }

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.customUserDetailsService.loadUserByUsername(username);

            if (jwtUtil.validateToken(jwt, userDetails)) {
                // Extract roles from the JWT token
                Claims claims = jwtUtil.extractAllClaims(jwt);
                String role = claims.get("role", String.class);

                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                        new UsernamePasswordAuthenticationToken(
                                userDetails, null, Collections.singletonList(new SimpleGrantedAuthority(role)));
                usernamePasswordAuthenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }
        chain.doFilter(request, response);
    }
    // Method to check if the request URI matches a public endpoint
    private boolean isPublicEndpoint(String requestURI) {
        return requestURI.startsWith("/api/users/creer-user") ||
                requestURI.startsWith("/api/files/") ||
                requestURI.startsWith("/api/users/reset-password-request") ||
                requestURI.startsWith("/api/users/reset-password") ||
                requestURI.startsWith("/images_du_projet/modules") ||
                requestURI.startsWith("/images_du_projet/");
    }
}
