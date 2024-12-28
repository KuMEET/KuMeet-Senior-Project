package com.example.kumeet.controller;

import com.example.kumeet.Dto.UserDto;
import com.example.kumeet.Model.Users;
import com.example.kumeet.Service.UserService;
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
    @GetMapping("/find/{userName}")
    public Users findUser(@PathVariable String userName) {
        return userService.findByUserName(userName);
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
