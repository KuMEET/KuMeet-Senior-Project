package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.LoginDto;
import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Service.LoginAuthenticationService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/auth")
public class LoginController {
    @Autowired
    private LoginAuthenticationService loginAuthenticationService;
    @PostMapping("/register")
    public ResponseEntity<String> addUser(@RequestBody LoginDto loginDto) {
        return loginAuthenticationService.login(loginDto);
    }
}
