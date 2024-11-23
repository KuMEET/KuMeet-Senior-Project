package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.UserGroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.http.HttpResponse;
import java.util.UUID;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserGroupServiceController {
    @Autowired
    private UserGroupService userGroupService;
    @PostMapping("/add-to-group/{userId}/{groupId}")
    public ResponseEntity<String> userAddToGroup(@PathVariable UUID userId, @PathVariable UUID groupId){
        return userGroupService.UserAddToGroup(userId, groupId);
    }
    @DeleteMapping("/remove-from-group/{userId}/{groupId}")
    public ResponseEntity<String> deleteUserFromGroupController(@PathVariable UUID userId, @PathVariable UUID groupId){
        return userGroupService.deleteUserFromGroup(userId, groupId);
    }
    @PutMapping("/update-role/{userId}/{groupId}/{role}")
    public ResponseEntity<String> updateUserRoleInGroupController(@PathVariable UUID userId, @PathVariable UUID groupId, @PathVariable String role){
        return userGroupService.updateUserRoleInGroup(userId, groupId, role);
    }


}
