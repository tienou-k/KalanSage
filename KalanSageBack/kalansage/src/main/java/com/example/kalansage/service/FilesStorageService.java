package com.example.kalansage.service;

import com.example.kalansage.model.FileInfo;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;
import java.util.stream.Stream;

public interface FilesStorageService {
    public void init();

    public void save(MultipartFile file);

    public Resource load(String filename);

    public void deleteAll();

    public Stream<Path> loadAll();

    // Save file in a specific folder with a custom name
    FileInfo saveFileInSpecificFolderWithCustomName(MultipartFile file, String folderPath, String customFileName) throws IOException;

    FileInfo saveFileInSpecificFolderWithCustomNameVideo(MultipartFile file, String folderPath, String customFileName) throws IOException;
}
