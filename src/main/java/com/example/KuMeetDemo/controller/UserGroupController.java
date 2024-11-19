package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.UserGroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class UserGroupController {
    @Autowired
    private UserGroupService userGroupService;

    @PostMapping("/add-group/{id}/{username}")
    public void addUserToGroupController(@PathVariable String id, @PathVariable String username) {
        userGroupService.addUserToGroup(username, id);
    }
    @DeleteMapping("/delete-group/{username}/{id}")
    public void deleteUserFromGroupController(@PathVariable String username, @PathVariable String id) {
        userGroupService.deleteUserFromGroup(username, id);
    }
}
