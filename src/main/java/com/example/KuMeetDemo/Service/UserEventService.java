package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserEventDto;
import com.example.KuMeetDemo.Dto.UserGroupDto;
import com.example.KuMeetDemo.Model.UserEvent;
import com.example.KuMeetDemo.Model.UserGroup;
import com.example.KuMeetDemo.Repository.UserEventRepository;
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

    public List<UserEvent> findAll(){
        return userEventRepository.findAll();
    }

    public UserEvent findById(UUID id){
        UserEvent userEvent = userEventRepository.findById(id);
        return userEvent;
    }
    public UserEvent save(UserEventDto userEventDto){
        UserEvent userEvent = new UserEvent();
        userEvent.setUserId(userEventDto.getUserId());
        userEvent.setId(UUID.randomUUID());
        userEvent.setRole(userEventDto.getRole());
        userEvent.setEventId(userEventDto.getEventId());
        userEvent.setRegisterTime(new Date(System.currentTimeMillis()));
        return userEventRepository.save(userEvent);
    }
    public UserEvent update(UserEventDto userEventDto){
        if(!ObjectUtils.isEmpty(userEventDto.getId())){
            UserEvent userGroup = userEventRepository.findById(userEventDto.getId());
            userGroup.setRole(userEventDto.getRole());
            return userEventRepository.save(userGroup);
        }
        return null;
    }
    public void delete(String id){
        userEventRepository.deleteById(id);
    }

}
