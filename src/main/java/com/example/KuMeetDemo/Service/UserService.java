package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    // create method
    public User registerUser(UserDto userDto) {
        User user = new User();
        user.setUserName(userDto.getUserName());
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setId(UUID.randomUUID());
        return userRepository.save(user);
    }

    public User updateUser(String userId, UserDto userDto) {
        User user = userRepository.findById(userId).orElse(null);
        if(!ObjectUtils.isEmpty(user)){
            user.setUserName(userDto.getUserName());
            user.setName(userDto.getName());
            user.setSurname(userDto.getSurname());
            user.setEMail(userDto.getEmail());
            user.setPassWord(userDto.getPassword());
            user.setCreatedAt(new Date(System.currentTimeMillis()));
            user = userRepository.save(user);
            return user;
        }
        return null;

    }

    public User deleteUser(String userId) {
        User user = userRepository.findById(userId).orElse(null);
        if(!ObjectUtils.isEmpty(user)){
            userRepository.delete(user);
            return user;
        }
        return null;
    }


    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User findUser(String userId) {
        return userRepository.findById(userId).orElse(null);
    }
}
