package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<Users> addUser(@RequestBody UserDto user) {
        return userService.registerUser(user);
    }
    @GetMapping("/find/{userId}")
    public Users findUser(@PathVariable UUID userId) {
        return userService.findUser(userId);
    }

    @PutMapping("/update/{userName}")
    public Users updateUser(@PathVariable String userName, @RequestBody UserDto user) {
        return userService.updateUser(userName, user);
    }

    @DeleteMapping("/delete-user/{userId}")
    public Users deleteUser(@PathVariable UUID userId) {
        return userService.deleteUser(userId);
    }

    @GetMapping("/get-all-users")
    public List<Users> getAllUser() {
        return userService.getAllUsers();
    }











}
