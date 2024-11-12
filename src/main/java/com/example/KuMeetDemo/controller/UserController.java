package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
    public User findUser(@PathVariable String userName) {
        return userService.findUser(userName);
    }

    @PutMapping("/update/{userName}")
    public User updateUser(@PathVariable String userName, @RequestBody UserDto user) {
        return userService.updateUser(userName, user);
    }

    @DeleteMapping("/delete/{userName}")
    public User deleteUser(@PathVariable String userName){
        return userService.deleteUser(userName);
    }








}
