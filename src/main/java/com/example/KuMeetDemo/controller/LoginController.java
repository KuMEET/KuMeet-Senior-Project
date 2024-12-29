package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.LoginDto;
import com.example.KuMeetDemo.Service.LoginAuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class LoginController {
    @Autowired
    private LoginAuthenticationService loginAuthenticationService;
    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody LoginDto loginDto) {
        return loginAuthenticationService.login(loginDto);
    }
}
