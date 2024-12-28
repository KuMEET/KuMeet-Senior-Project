package com.example.kumeet.controller;

import com.example.kumeet.Dto.LoginDto;
import com.example.kumeet.Service.LoginAuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/auth")
public class LoginController {
    @Autowired
    private LoginAuthenticationService loginAuthenticationService;
    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody LoginDto loginDto) {
        return loginAuthenticationService.login(loginDto);
    }
}
