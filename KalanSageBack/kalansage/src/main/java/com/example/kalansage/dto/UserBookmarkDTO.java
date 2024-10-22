package com.example.kalansage.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserBookmarkDTO {
    private Long id;
    private Long userId;
    private Long moduleId;
    private LocalDateTime bookmarkDate;


}
