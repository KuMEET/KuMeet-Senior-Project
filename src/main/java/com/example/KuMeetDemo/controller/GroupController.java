package com.example.KuMeetDemo.controller;


import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Model.Groups;
import com.example.KuMeetDemo.Service.GroupService;
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
public class GroupController {
    @Autowired
    private GroupService groupService;

    @PostMapping("/creategroup")
    public ResponseEntity<Groups> GroupCreate(@RequestBody GroupDto group) {
        return groupService.createGroup(group);
    }

    @GetMapping("/get-groups")
    public List<Groups> getAllGroup() {
        return groupService.getAllGroups();
    }
    @DeleteMapping("/delete-group")
    public void deleteGroup(@RequestParam UUID id) {
        groupService.deleteGroup(id);
    }
    @PostMapping("/update-group")
    public ResponseEntity<Groups> updateGroup(@RequestBody GroupDto group) {
        return groupService.updateGroup(group);
    }
    @GetMapping("/find-group")
    public Groups findGroup(@RequestParam UUID id) {
        return groupService.findGroupById(id);
    }


}
