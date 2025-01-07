package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VerificationTokenService {
    @Autowired
    private UserRepository userRepository;

    public void createVerificationToken(Users user, String token) {
        user.setVerificationToken(token);
        userRepository.save(user);
    }

    public String validateVerificationToken(String token) {
        Users user = userRepository.findByVerificationToken(token).orElse(null);
        if (user == null) {
            return "invalid";
        }
        user.setEnabled(true);
        userRepository.save(user);
        return "valid";
    }
}
