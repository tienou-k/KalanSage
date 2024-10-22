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
   /* public FileInfo saveFileInSpecificFolderWithCustomName(MultipartFile file, String folderPath, String customFileName) throws IOException {
        // Create folderPath as a Path object inside static directory
        Path mfolderPath = Paths.get(rootLocation.toString(), folderPath);
        if (!Files.exists(mfolderPath)) {
            Files.createDirectories(mfolderPath);
        }
        Path destinationFile = mfolderPath.resolve(customFileName).normalize().toAbsolutePath();
        Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);
        String fileUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images_du_projet/modules/")
                .path(folderPath + "/")
                .path(customFileName)
                .toUriString();

        // Return file information with URL
        return new FileInfo(customFileName, fileUrl);
    }*/
    FileInfo saveFileInSpecificFolderWithCustomName(MultipartFile file, String folderPath, String customFileName) throws IOException;

    FileInfo saveFileInSpecificFolderWithCustomNameVideo(MultipartFile file, String folderPath, String customFileName) throws IOException;
}
