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
    private Date bookmarkDate;


}
