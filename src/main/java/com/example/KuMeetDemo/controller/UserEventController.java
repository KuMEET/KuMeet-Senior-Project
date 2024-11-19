package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.UserEventService;
import com.example.KuMeetDemo.Service.UserGroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserEventController {
    @Autowired
    private UserEventService userEventService;

    @PostMapping("/add-group/{userId}/{eventId}")
    public void addUserToEvent(@PathVariable String userId, @PathVariable String eventId) {
        userEventService.addUserToEvent(userId, eventId);
    }
    @DeleteMapping("/delete-group/{userId}/{eventId}")
    public void deleteUserFromEvent(@PathVariable String userId, @PathVariable String eventId) {
        userEventService.deleteUserFromEvent(userId, eventId);
    }
}
