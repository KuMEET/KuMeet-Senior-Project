package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Service.UserGroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class UserGroupServiceController {
    @Autowired
    private UserGroupService userGroupService;
    @PostMapping("/add-to-group/{userName}/{groupId}")
    public ResponseEntity<String> userAddToGroup(@PathVariable String userName, @PathVariable UUID groupId){
        return userGroupService.UserAddToGroup(userName, groupId);
    }
    @DeleteMapping("/remove-from-group/{userName}/{groupId}")
    public ResponseEntity<String> deleteUserFromGroupController(@PathVariable String userName, @PathVariable UUID groupId){
        return userGroupService.deleteUserFromGroup(userName, groupId);
    }
    @PutMapping("/update-role/{userName}/{groupId}/{role}")
    public ResponseEntity<String> updateUserRoleInGroupController(@PathVariable String userName, @PathVariable UUID groupId, @PathVariable String role){
        return userGroupService.updateUserRoleInGroup(userName, groupId, role);
    }
    @GetMapping("/get-groups-by-username/{userName}")
    public ResponseEntity<List<GroupReference>> getGroupsByUsername(@PathVariable String userName){
        return userGroupService.getGroupsByUsername(userName);
    }

}
