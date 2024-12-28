package com.example.kumeet.controller;

import com.example.kumeet.Dto.UserReference;
import com.example.kumeet.Model.Groups;
import com.example.kumeet.Service.UserGroupService;
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
    public ResponseEntity<List<Groups>> getGroupsByUsername(@PathVariable String userName){
        return userGroupService.getGroupsByUsername(userName);
    }
    @GetMapping("/get-groups-for-admin/{userName}")
    public ResponseEntity<List<Groups>> getGroupsForAdmin(@PathVariable String userName){
        return userGroupService.getGroupsForAdmin(userName);
    }

    @GetMapping("/get-pending-groups-for-admin/{groupId}")
    public ResponseEntity<List<UserReference>> viewPendingUsersForGroup(@PathVariable UUID groupId){
        return userGroupService.viewPendingUsersForGroup(groupId);
    }
    @PostMapping("/approve-pending-groups-for-admin/{groupId}/{userId}")
    public ResponseEntity<String> approveUserRequestForGroup(@PathVariable UUID groupId, @PathVariable UUID userId){
        return userGroupService.approveUserRequestForGroup(groupId, userId);
    }
    @PostMapping("/reject-pending-groups-for-admin/{groupId}/{userId}")
    public ResponseEntity<String> rejectUserRequestForGroup(@PathVariable UUID groupId, @PathVariable UUID userId){
        return userGroupService.rejectUserRequestForGroup(groupId, userId);
    }


}
