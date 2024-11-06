package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.RegisterUserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Currency;
import java.util.Date;
@Data
@Service
public class UserService {
    @Autowired
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User registerUser(RegisterUserDto userDto) {
        User user = new User();
        user.setUserName(userDto.getUserName());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt("123");
        // sistem atamalı
        user.setUserId("12");
        return userRepository.save(user);
    }
}
