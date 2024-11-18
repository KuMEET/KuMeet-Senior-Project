package com.example.KuMeetDemo.controller;


import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Model.Group;
import com.example.KuMeetDemo.Service.GroupService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


// c289a1f6-ee76-4b7a-bb45-73ff6908757c
@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class GroupController {
    @Autowired
    private GroupService groupService;

    @PostMapping("/creategroup")
    public Group GroupCreate(@RequestBody GroupDto group) {
        return groupService.createGroup(group);
    }

    @GetMapping("/get-groups")
    public List<Group> getAllGroup() {
        return groupService.getAllGroups();
    }



}
