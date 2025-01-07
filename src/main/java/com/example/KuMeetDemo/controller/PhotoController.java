package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.PhotoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class PhotoController {
    @Autowired
    private PhotoService photoService;

    @PostMapping("/photos/add")
    public ResponseEntity<String> addPhoto(@RequestParam("title") String title, @RequestParam("image") MultipartFile image) {
        return photoService.addPhoto(title, image);
    }

}