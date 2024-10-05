package com.example.kalansage.service;


import com.example.kalansage.model.FileInfo;
import com.example.kalansage.repository.FileInfoRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class FileInfoService {
    private FileInfoRepository fileInfoRepository;

    @Transactional
    public FileInfo creer(FileInfo fileInfo) {
        return this.fileInfoRepository.save(fileInfo);
    }
}
