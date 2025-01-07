package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Model.Photo;
import com.example.KuMeetDemo.Repository.PhotoRepository;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class PhotoService {

    @Autowired
    private PhotoRepository photoRepo;

    public ResponseEntity<String> addPhoto(String title, MultipartFile file) {
        try {
            Photo photo = new Photo(title);
            photo.setImage(new Binary(BsonBinarySubType.BINARY, file.getBytes()));
            photo = photoRepo.insert(photo);
            return ResponseEntity.ok(photo.getId());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Failed to upload image");
        }
    }
}