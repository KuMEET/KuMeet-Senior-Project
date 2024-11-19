package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserController {
    @Autowired
    private UserService userService;


    // hata codeları, success ve mesaj
    @PostMapping("/register")
    public User addUser(@RequestBody UserDto user) {
        return userService.registerUser(user);
    }
    @GetMapping("/find/{userName}")
    public User findUser(@PathVariable UUID userId) {
        return userService.findUserByUserId(userId);
    }

    @PutMapping("/update/{userName}")
    public User updateUser(@PathVariable String userName, @RequestBody UserDto user) {
        return userService.updateUser(user);
    }

    @DeleteMapping("/delete-user/{userId}")
    public User deleteUser(@PathVariable UUID userId) {
        return userService.deleteUser(userId);
    }
    // 22bb2288-d641-49ac-954a-accd21357b9f

    @GetMapping("/get-all-users")
    public List<User> getAllUser() {
        return userService.getAllUsers();
    }







}
