package com.example.kalansage.service;

import com.example.kalansage.model.FileInfo;
import com.example.kalansage.repository.FileInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.stream.Stream;

@Service
public class FilesStorageServiceImpl implements FilesStorageService {

    // This is the path to your static folder under the resources directory
    private final Path root = Paths.get("src/main/resources/static/images_du_projet");
    private final Path rootLocation = Paths.get("src/main/resources/static/images_du_projet/modules");
    private final Path rootLecon = Paths.get("src/main/resources/static/images_du_projet/videos_lecons");

    // Extensions autorisées pour les fichiers
    private final String[] extensionsImages = { "jpg", "jpeg", "png", "gif" };
    private final String[] extensionsVideo = { "mp4", "avi", "mov", "wmv" };

    @Autowired
    private FileInfoRepository fileInfoRepository;

    @Override
    public void init() {
        try {
            // Create directories inside static folder if they don't exist
            if (!Files.exists(root)) {
                Files.createDirectories(root);
            }
            if (!Files.exists(rootLocation)) {
                Files.createDirectories(rootLocation);
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize folder for upload!");
        }
    }

    @Override
    public void save(MultipartFile file) {
        try {
            // Save the file inside the static directory
            Files.copy(file.getInputStream(), this.root.resolve(file.getOriginalFilename()));
        } catch (Exception e) {
            throw new RuntimeException("Could not store the file. Error: " + e.getMessage());
        }
    }

    @Override
    public Resource load(String filename) {
        try {
            // Try to resolve the file from the static directory
            Path file = root.resolve(filename);
            Resource resource = new UrlResource(file.toUri());

            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new RuntimeException("Could not read the file!");
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Error: " + e.getMessage());
        }
    }

    @Override
    public void deleteAll() {
        FileSystemUtils.deleteRecursively(root.toFile());
    }

    @Override
    public Stream<Path> loadAll() {
        try {
            // Load all files from the directory
            return Files.walk(this.root, 1).filter(path -> !path.equals(this.root)).map(this.root::relativize);
        } catch (IOException e) {
            throw new RuntimeException("Could not load the files!");
        }
    }

    // Save file with a unique name in the static folder
    public FileInfo saveFile(MultipartFile file) throws IOException {
        String uniqueFileName = generateUniqueFilename();
        Path fileStorageLocation = root.toAbsolutePath().normalize();

        if (!Files.exists(fileStorageLocation)) {
            Files.createDirectories(fileStorageLocation);
        }
        // Vérifie si le fichier est une vidéo
        if (!estExtensionValide(file.getOriginalFilename(), extensionsVideo)) {
            throw new IOException("Le fichier n'est pas une vidéo valide.");
        }// Vérifie si le fichier est une image
        if (!estExtensionValide(file.getOriginalFilename(), extensionsImages)) {
            throw new IOException("Le fichier n'est pas une image valide.");
        }

        Path targetLocation = fileStorageLocation.resolve(uniqueFileName);
        Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

        FileInfo fileInfo = new FileInfo();
        fileInfo.setNom(uniqueFileName);

        // Generate URL dynamically with ServletUriComponentsBuilder
        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images_du_projet/modules/")
                .path(uniqueFileName)
                .toUriString();

        fileInfo.setUrl(fileDownloadUri);

        return fileInfoRepository.save(fileInfo);
    }
    private boolean estExtensionValide(String nomFichier, String[] extensionsAutorisees) {
        if (nomFichier == null) {
            return false;
        }
        String extension = nomFichier.substring(nomFichier.lastIndexOf('.') + 1).toLowerCase();
        for (String ext : extensionsAutorisees) {
            if (ext.equals(extension)) {
                return true;
            }
        }
        return false;
    }
    // Save file in a specific folder with a custom name
    public FileInfo saveFileInSpecificFolderWithCustomName(MultipartFile file, String folderPath, String customFileName) throws IOException {
        // Create folderPath as a Path object inside static directory
        Path mfolderPath = Paths.get(rootLocation.toString(), folderPath);
        if (!Files.exists(mfolderPath)) {
            Files.createDirectories(mfolderPath);
        }
        Path destinationFile = mfolderPath.resolve(customFileName).normalize().toAbsolutePath();
        Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);

        // Adjust file URL construction
        String fileUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images_du_projet/modules/")
                .path(customFileName) // Ensure folderPath is not added again
                .toUriString();

        // Log for debugging
        System.out.println("Folder path: " + mfolderPath);
        System.out.println("Destination file: " + destinationFile);
        System.out.println("File URL: " + fileUrl);

        // Return file information with URL
        return new FileInfo(customFileName, fileUrl);
    }


    @Override
    public FileInfo saveFileInSpecificFolderWithCustomNameVideo(MultipartFile file, String folderPath, String customFileName) throws IOException {
        // Check if file is a valid video
        if (!Objects.requireNonNull(file.getContentType()).startsWith("video/")) {
            throw new IllegalArgumentException("fichier en video uniquement !");
        }
        // Create folderPath if it doesn't exist
        Path vfolderPath = Paths.get(rootLecon.toString(), folderPath);
        if (!Files.exists(vfolderPath)) {
            Files.createDirectories(vfolderPath);
        }
        Path destinationFile = vfolderPath.resolve(customFileName).normalize().toAbsolutePath();
        Files.copy(file.getInputStream(), destinationFile, StandardCopyOption.REPLACE_EXISTING);

        // Generate file URL dynamically
        String fileUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images_du_projet/videos_lecons/")
                .path(folderPath + "/")
                .path(customFileName)
                .toUriString();
        // Return file information with URL
        return new FileInfo(customFileName, fileUrl);
    }

    // Helper method to generate a unique file name
    private String generateUniqueFilename() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "module_" + timestamp ;
    }
}
