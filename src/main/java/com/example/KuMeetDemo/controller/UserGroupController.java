package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Model.UserGroup;
import com.example.KuMeetDemo.Service.UserGroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserGroupController {
    @Autowired
    private UserGroupService userGroupService;

    @PostMapping("/add-group/{id}/{username}")
    public UserGroup addUserToGroupController(@PathVariable String id, @PathVariable String username) {
        return userGroupService.addUserToGroup(username, id);
    }
    @DeleteMapping("/delete-group/{username}/{id}")
    public UserGroup deleteUserFromGroupController(@PathVariable String username, @PathVariable String id) {
        return userGroupService.deleteUserFromGroup(username, id);
    }
    @PutMapping("/update-user-group")
    public UserGroup updateUserGroup(@RequestBody UserGroup userGroup) {
        return userGroupService.update(userGroup);
    }
    @GetMapping("/getAll-user-group")
    public List<UserGroup> getAllUserGroup() {
        return userGroupService.findAll();
    }
    @GetMapping("/find-user-group")
    public UserGroup findUserGroup(@RequestParam String id) {
        return userGroupService.findById(id);
    }
}
