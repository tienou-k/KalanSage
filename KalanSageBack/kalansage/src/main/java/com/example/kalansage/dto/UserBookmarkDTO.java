package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserBookmarkDTO {
    private Long id;
    private Long userId;
    private Long moduleId;
    private String titre;
    private String description;
    private double prix;
    private String imageUrl;
    private Date bookmarkDate;

    /* Full constructor with all fields
    public UserBookmarkDTO(
            Long id,
            Long userId,
            Long moduleId,
            String titre,
            String description,
            double prix,
            String imageUrl,
            Date bookmarkDate
    ) {
        this.id = id;
        this.userId = userId;
        this.moduleId = moduleId;
        this.titre = titre;
        this.description = description;
        this.prix = prix;
        this.imageUrl = imageUrl;
        this.bookmarkDate = bookmarkDate;
    }*/
}
