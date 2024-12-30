package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Service.UserEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class UserEventController {
    @Autowired
    private UserEventService userEventService;
    @PostMapping("/add-to-event/{userName}/{eventId}")
    public ResponseEntity<String> userAddToEventController(@PathVariable String userName, @PathVariable String eventId){
        return userEventService.UserAddToEvent(userName, eventId);
    }
    @DeleteMapping("/remove-from-event/{userName}/{eventId}")
    public ResponseEntity<String> userDeleteFromEventController(@PathVariable String userName, @PathVariable String eventId){
        return userEventService.deleteUserFromEvent(userName, eventId);
    }
    @PutMapping("/update-role-event/{userName}/{eventId}/{role}")
    public ResponseEntity<String> updateUserRoleInEventController(@PathVariable String userName, @PathVariable String eventId, @PathVariable String role){
        return userEventService.updateUserRoleInEvent(userName, eventId, role);
    }
    @GetMapping("/get-events-by-username/{userName}")
    public ResponseEntity<List<Events>> getEventsByUsername(@PathVariable String userName){
        return userEventService.getEventsByUsername(userName);
    }
    @GetMapping("/get-events-for-admin/{userName}")
    public ResponseEntity<List<Events>> getEventsForAdmin(@PathVariable String userName){
        return userEventService.getEventsForAdmin(userName);
    }
    @GetMapping("/get-pending-events-for-admin/{eventId}")
    public ResponseEntity<List<UserReference>> viewPendingUsers(@PathVariable String eventId){
        return userEventService.viewPendingUsers(eventId);
    }
    @GetMapping("/get-admins-for-event/{eventId}")
    public ResponseEntity<List<Users>> getAdminsForEvent(@PathVariable String eventId){
        return userEventService.getAdminsForEvent(eventId);
    }
    @PostMapping("/approve-pending-events-for-admin/{eventId}/{userId}")
    public ResponseEntity<String> approveUserRequest(@PathVariable String eventId, @PathVariable String userId){
        return userEventService.approveUserRequest(eventId, userId);
    }
    @PostMapping("/reject-pending-events-for-admin/{eventId}/{userId}")
    public ResponseEntity<String> rejectUserRequest(@PathVariable String eventId, @PathVariable String userId){
        return userEventService.rejectUserRequest(eventId, userId);
    }

}
