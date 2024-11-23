package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.UserEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

import java.util.UUID;

public class UserEventController {
    @Autowired
    private UserEventService userEventService;
    @PostMapping("/add-to-event/{userId}/{groupId}")
    public ResponseEntity<String> userAddToEventController(@PathVariable UUID userId, @PathVariable UUID evenId){
        return userEventService.UserAddToEvent(userId, evenId);
    }
    @DeleteMapping("/remove-from-event/{userId}/{groupId}")
    public ResponseEntity<String> userDeleteFromEventController(@PathVariable UUID userId, @PathVariable UUID eventId){
        return userEventService.deleteUserFromEvent(userId, eventId);
    }
    @PutMapping("/update-role-event/{userId}/{groupId}/{role}")
    public ResponseEntity<String> updateUserRoleInEventController(@PathVariable UUID userId, @PathVariable UUID evenId, @PathVariable String role){
        return userEventService.updateUserRoleInEvent(userId, evenId, role);
    }
}
