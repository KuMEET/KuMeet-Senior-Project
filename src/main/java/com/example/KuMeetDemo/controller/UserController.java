package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.RegisterUserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserController {
    @Autowired
    private UserService userService;


    // hata codeları, success ve mesaj
    @PostMapping("/register")
    public User addUser(@RequestBody RegisterUserDto user) {
        return userService.registerUser(user);
    }



}
