package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.Optional;
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
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setUserId(UUID.randomUUID());
        return userRepository.save(user);
    }
    public User findUserByUserId(UUID userId) {
        User user = userRepository.findById(userId);
        if (ObjectUtils.isEmpty(user)) {
            return null;
        }
        return user;
    }


    public User updateUser(UserDto userDto) {
        if(!ObjectUtils.isEmpty(userDto)){
            User user =  userRepository.findById(userDto.getId());
            if(!ObjectUtils.isEmpty(user)){

                user.setUserName(userDto.getUserName());
                user.setEMail(userDto.getEmail());
                user.setPassWord(userDto.getPassword());
                user.setCreatedAt(new Date(System.currentTimeMillis()));
                user = userRepository.save(user);
                return user;
            }
        }
        return null;

    }

    public User deleteUser(UUID userId) {
        User user = userRepository.findById(userId);
        if(!ObjectUtils.isEmpty(user)){
            userRepository.delete(user);
            return user;
        }
        return null;
    }





}
