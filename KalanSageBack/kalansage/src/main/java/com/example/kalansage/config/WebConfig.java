package com.example.kalansage.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(
                "/images_du_projet/modules/**",
                "/images_du_projet/videos_lecons/**"
                        )
                .addResourceLocations(
                        "classpath:/static/images_du_projet/modules/",
                        "classpath:/static/images_du_projet/videos_lecons/"
                );
    }
}
