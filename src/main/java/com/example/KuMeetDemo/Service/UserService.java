package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.RegisterUserDto;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Currency;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@Data
@Service
public class UserService {
    @Autowired
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // create method
    public User registerUser(RegisterUserDto userDto) {
        User user = new User();
        user.setUserName(userDto.getUserName());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setUserId(UUID.randomUUID().toString());
        return userRepository.save(user);
    }
    // read method
    public User findUser(String userName) {
        return userRepository.findByUserName(userName).orElse(null);
    }


    public User updateUser(String userName, RegisterUserDto userDto) {
        User newUser = new User();
        if(!ObjectUtils.isEmpty(userDto)){
            User user = userRepository.findByUserName(userName).get();
            newUser.setUserName(userDto.getUserName());
            newUser.setEMail(userDto.getUserName());
            newUser.setPassWord(userDto.getUserName());
            newUser.setCreatedAt(new Date(System.currentTimeMillis()));
            newUser = userRepository.save(newUser);
            return newUser;
        }
        return null;

    }

    public User deleteUser(String userName) {
        Optional<User> userOptional = userRepository.findByUserName(userName);
        if (userOptional.isPresent()) {
            userRepository.deleteByUserName(userName);
            return userOptional.get();  // Return the deleted user
        }
        return null;
    }





}
