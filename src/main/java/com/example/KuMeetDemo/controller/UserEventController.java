package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Model.UserEvent;
import com.example.KuMeetDemo.Service.UserEventService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserEventController {
    @Autowired
    private UserEventService userEventService;

    @PostMapping("/add-group/{userId}/{eventId}")
    public UserEvent addUserToEvent(@PathVariable String userId, @PathVariable String eventId) {
        return userEventService.addUserToEvent(userId, eventId);
    }
    @DeleteMapping("/delete-group/{userId}/{eventId}")
    public UserEvent deleteUserFromEvent(@PathVariable String userId, @PathVariable String eventId) {
        return userEventService.deleteUserFromEvent(userId, eventId);
    }
    @PutMapping("/update-user-event")
    public UserEvent updateUserGroup(@RequestBody UserEvent userEvent) {
        return userEventService.update(userEvent);
    }
    @GetMapping("/getAll-user-event")
    public List<UserEvent> getAllUserGroup() {
        return userEventService.findAll();
    }
    @GetMapping("/find-user-event")
    public UserEvent findUserGroup(@RequestParam String id) {
        return userEventService.findById(id);
    }
}
