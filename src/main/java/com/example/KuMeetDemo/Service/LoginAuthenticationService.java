package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.LoginDto;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class LoginAuthenticationService {

    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<String> login(LoginDto loginDto) {
        // Check if user exists by email
        Users user = userRepository.findByUserName(loginDto.getUserName());
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        if (user != null) {
            if (passwordEncoder.matches(loginDto.getPassword(), user.getPassWord())) {
                return ResponseEntity.ok("Login successful"); // 200 OK
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid password");
            }

        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User could not be found!"); // 401 Unauthorized
        }
    }
}
