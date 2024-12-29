package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.*;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.*;

@Data
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private EmailService emailService;

    // create method
    public ResponseEntity<Users> registerUser(UserDto userDto) {
        // Check for null or missing fields in userDto
        if (userDto.getUserName() == null || userDto.getUserName().isEmpty() ||
                userDto.getEmail() == null || userDto.getEmail().isEmpty() ||
                userDto.getPassword() == null || userDto.getPassword().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }

        // Check if the user already exists by username or email
        Optional<Users> existingUser = userRepository.findByUserNameOrEMail(
                userDto.getUserName(), userDto.getEmail()
        );
        if (existingUser.isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null); // 409 Conflict
        }

        // Create and save the new user
        Users user = new Users();
        user.setUserName(userDto.getUserName());
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setId(UUID.randomUUID());

        Users savedUser = userRepository.save(user);
        // Return created response
        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser); // 201 Created
    }

    public String validateUser(String token) {
        Users user = userRepository.findByVerificationToken(token).orElse(null);
        if (user == null) {
            return "Invalid user";
        }
        user.setEnabled(true);
        userRepository.save(user);
        return "Valid user";
    }


    public Users findUserByUserId(UUID userId) {
        Users user = userRepository.findById(userId).get();
        if (ObjectUtils.isEmpty(user)) {
            return null;
        }
        if (user.isEnabled()) {
            return user;
        }
        return null;
    }

    public Users updateUser(String userName, UserDto userDto) {
        Users user = userRepository.findByUserName(userName);
        if (!ObjectUtils.isEmpty(user) && user.isEnabled()) {
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
    // user silinince ilgili olan group members listesinden de silinmek zorunda
    // user silinince ilgili olan event participants listesinden de silinmeli

    public Users deleteUser(UUID userId) {
        Users user = userRepository.findById(userId).orElse(null);
        for (Groups group : groupRepository.findAll()) {
            for (UserReference userReference : group.getMembers()) {
                if (userReference.getUserId().equals(user.getId())) {
                    group.setMemberCount(group.getMemberCount() - 1);
                    group.getMembers().remove(userReference);
                    groupRepository.save(group);
                    break;
                }
            }
        }

        for (Events events : eventRepository.findAll()) {
            for (UserReference userReference : events.getParticipants()) {
                if (userReference.getUserId().equals(user.getId())) {
                    events.setParticipantCount(events.getParticipantCount() - 1);
                    events.getParticipants().remove(userReference);
                    eventRepository.save(events);
                    break;
                }
            }
        }
        userRepository.delete(user);
        return user;
    }

    public List<Users> getAllUsers() {
        List<Users> enabledUsers = new ArrayList<Users>();
        List<Users> users = userRepository.findAll();
        users.forEach(x -> {
            if (x.isEnabled()) {
                enabledUsers.add(x);
            }
        });
        return enabledUsers;
    }

    public Users findUser(UUID userId) {
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return null;
        } else {
            if (user.isEnabled()) {
                return user;
            }
        }
        return null;

    }
    public Users findByUserName(String userName) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return null;
        }
        else {
            if (user.isEnabled()) {
                return user;
            }
        }
        return null;
    }
}
