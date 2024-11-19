package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.Group;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Model.UserGroup;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserGroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
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
        user.setName(userDto.getUserName());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setId(UUID.randomUUID());
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
            Optional<User> userOption =  userRepository.findById(userDto.getUserName());
            if(userOption.isPresent()){
                User user = userOption.get();
                user.setName(userDto.getUserName());
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


    // delete user from group

    public List<User> getUsersByName(String name) {
        return userRepository.findAllByName(name);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }














}
