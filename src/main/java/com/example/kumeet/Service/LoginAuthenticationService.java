package com.example.kumeet.Service;

import com.example.kumeet.Dto.LoginDto;
import com.example.kumeet.Model.Users;
import com.example.kumeet.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class LoginAuthenticationService {

    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<String> login(LoginDto loginDto) {
        // Check if user exists by email
        Users user = userRepository.findByUserName(loginDto.getUserName());
        if (user != null) {
            if (user.getPassWord().equals(loginDto.getPassword())) {
                return ResponseEntity.ok("Login successful"); // 200 OK
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid password");
            }

        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User could not be found!"); // 401 Unauthorized
        }
    }
}
