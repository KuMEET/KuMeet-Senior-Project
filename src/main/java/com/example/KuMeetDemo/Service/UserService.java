package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.*;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.GroupRepository;
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
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private EventRepository eventRepository;

    // create method
    public Users registerUser(UserDto userDto) {
        Users user = new Users();
        user.setUserName(userDto.getUserName());
        user.setName(userDto.getName());
        user.setSurname(userDto.getSurname());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setId(UUID.randomUUID());
        return userRepository.save(user);
    }
    public Users findUserByUserId(UUID userId) {
        Users user = userRepository.findById(userId).get();
        if (ObjectUtils.isEmpty(user)) {
            return null;
        }
        return user;
    }

    public Users updateUser(String userName, UserDto userDto) {
        Users user = userRepository.findByUserName(userName);
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
    // user silinince ilgili olan group members listesinden de silinmek zorunda
    // user silinince ilgili olan event participants listesinden de silinmeli

    public Users deleteUser(UUID userId) {
        Users user = userRepository.findById(userId).orElse(null);
        for (Groups group : groupRepository.findAll()){
            for (UserReference userReference : group.getMembers()){
                if (userReference.getUserId().equals(user.getId())){
                   group.setMemberCount(group.getMemberCount() - 1);
                   group.getMembers().remove(userReference);
                   groupRepository.save(group);
                    break;
                }
            }
        }

        for (Events events : eventRepository.findAll()){
            for (UserReference userReference : events.getParticipants()){
                if (userReference.getUserId().equals(user.getId())){
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
        return userRepository.findAll();
    }

    public Users findUser(UUID userId) {
        return userRepository.findById(userId).orElse(null);
    }


}
