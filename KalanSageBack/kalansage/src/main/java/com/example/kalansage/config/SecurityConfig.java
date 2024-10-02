package com.example.kalansage.config;


import com.example.kalansage.service.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Autowired
    private JwtRequestFilter jwtRequestFilter;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        // Public endpoints
                        .requestMatchers(
                                "/api/users/creer-user",
                                "/api/auth/login"
                        ).permitAll()
                        //  endpoints Globals
                        .requestMatchers("/api/auth/**").hasAnyRole("USER", "ADMIN")
                        // Admin endpoints
                        .requestMatchers("/api/admins/**").hasRole("ADMIN")
                        .requestMatchers("/api/admins/utilisateurs/**").hasRole("ADMIN")
                        .requestMatchers("/api/categories/creer-categorie").hasRole("ADMIN")
                        .requestMatchers("/api/modules/creer-module").hasRole("ADMIN")
                        .requestMatchers("/api/modules/modifier-module").hasRole("ADMIN")
                        .requestMatchers("/api/modules/supprimer-module").hasRole("ADMIN")
                        .requestMatchers("/api/lecons/creer-lecon").hasRole("ADMIN")
                        .requestMatchers("/api/lecons/modifier-lecon").hasRole("ADMIN")
                        .requestMatchers("/api/lecons/supprimer-lecon").hasRole("ADMIN")
                        .requestMatchers("/api/admins/abonnements/**").hasRole("ADMIN")
                        .requestMatchers("/api/forums/**").hasRole("ADMIN")
                        .requestMatchers("/api/admins/partenaires/**").hasRole("ADMIN")
                        // User endpoints
                        .requestMatchers("/api/users/list-users").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/users/modifier-user").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/user-interaction").hasRole("USER")


                        .anyRequest().authenticated()
                )
                .exceptionHandling(exception -> exception.authenticationEntryPoint(jwtAuthenticationEntryPoint))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
