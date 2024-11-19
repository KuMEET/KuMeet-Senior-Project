package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Model.Event;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Model.UserEvent;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.UserEventRepository;
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
public class UserEventService {
    @Autowired
    private UserEventRepository userEventRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EventRepository eventRepository;

    public List<UserEvent> findAll(){
        return userEventRepository.findAll();
    }

    public UserEvent findById(String id){
        return userEventRepository.findById(id).orElse(null);
    }
    public UserEvent update(UserEvent updatedUserEvent){
        UserEvent userGroup = userEventRepository.findById(String.valueOf(updatedUserEvent.getId())).orElse(null);
        if(ObjectUtils.isEmpty(userGroup)){
            return null;
        }
        userGroup.setRole(updatedUserEvent.getRole());
        userEventRepository.save(userGroup);
        return userGroup;
    }
    public void delete(String id){
        userEventRepository.deleteById(id);
    }

    public UserEvent addUserToEvent(String userId, String eventId) {
        Event event = eventRepository.findById(eventId).orElse(null);
        User user = userRepository.findById(userId).orElse(null);
        if(event != null && user != null){
            UserEvent userEvent = new UserEvent();
            userEvent.setUserId(user.getId());
            userEvent.setId(UUID.randomUUID());
            userEvent.setRole("userEventDto.getRole()");
            userEvent.setEventId(event.getId());
            userEvent.setRegisterTime(new Date(System.currentTimeMillis()));
            return userEventRepository.save(userEvent);
        }
        return null;
    }

    public UserEvent deleteUserFromEvent(String userId, String eventId) {
        User user = userRepository.findById(userId).orElse(null);
        Event event = eventRepository.findById(eventId).orElse(null);
        if(event != null && user != null){
            UserEvent userEvent = userEventRepository.findByUserIdAndEventId(user.getId(),event.getId());
            if(userEvent != null){
                userEventRepository.delete(userEvent);
                return userEvent;
            }
            return null;
        }
        return null;
    }
}
