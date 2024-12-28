package com.example.kumeet.controller;


import com.example.kumeet.Dto.GroupDto;
import com.example.kumeet.Model.Groups;
import com.example.kumeet.Service.GroupService;
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

    @PostMapping("/creategroup/{username}")
    public ResponseEntity<Groups> GroupCreate(@RequestBody GroupDto group, @PathVariable String username) {
        return groupService.createGroup(group, username);
    }

    @GetMapping("/get-groups")
    public List<Groups> getAllGroup() {
        return groupService.getAllGroups();
    }
    @DeleteMapping("/delete-group")
    public void deleteGroup(@RequestBody Groups group) {
        groupService.deleteGroup(group.getId());
    }
    @PostMapping("/update-group/{groupId}")
    public ResponseEntity<Groups> updateGroup(@PathVariable String groupId, @RequestBody GroupDto groupDto) {
        return groupService.updateGroup(groupId, groupDto);
    }
    @GetMapping("/find-group")
    public Groups findGroup(@RequestParam UUID id) {
        return groupService.findGroupById(id);
    }
    @GetMapping("/get-all-groups-category/{category}")
    public ResponseEntity<List<Groups>> FilterGroupsBasedOnCategories(@PathVariable String category) {
        return groupService.FilterGroupsBasedOnCategories(category);
    }


}
