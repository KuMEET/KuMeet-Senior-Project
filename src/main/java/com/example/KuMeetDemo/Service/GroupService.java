package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Model.Groups;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Data
@Service
public class GroupService {
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<Groups> createGroup(GroupDto groupDto) {
        // Validate input
        if (groupDto.getName() == null || groupDto.getName().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        if (groupDto.getCapacity() <= 0) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }


        Optional<Groups> existingGroups = groupRepository.findById(
                groupDto.getId()
        );

        // Check for existing group with the same name
        if (existingGroups.isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null); // 409 Conflict
        }

        // Create new group
        Groups group = new Groups();
        group.setGroupName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        group.setCreatedAt(new Date(System.currentTimeMillis()));
        group.setId(groupDto.getId());

        try {
            Groups savedGroup = groupRepository.save(group);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedGroup); // 201 Created
        } catch (Exception e) {
            // Log the exception (using your preferred logging framework)
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 500 Internal Server Error
        }
    }

    public List<Groups> getAllGroups() {
        return groupRepository.findAll();
    }

    public ResponseEntity<Groups> updateGroup(GroupDto updatedGroupDto) {
        if (updatedGroupDto.getId() == null) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }

        Groups group = groupRepository.findById(updatedGroupDto.getId()).orElse(null);
        if (group == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null); // 404 Not Found
        }

        if (updatedGroupDto.getName() == null || updatedGroupDto.getName().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }

        if (updatedGroupDto.getCapacity() <= 0) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }

        group.setGroupName(updatedGroupDto.getName());
        group.setCapacity(updatedGroupDto.getCapacity());

        try {
            Groups updatedGroup = groupRepository.save(group);
            return ResponseEntity.ok(updatedGroup); // 200 OK
        } catch (Exception e) {
            // Log the exception (using your preferred logging framework)
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 500 Internal Server Error
        }
    }

    // herbir relation icin cascade deletingi manüel yapmalıyız
    public void deleteGroup(UUID id) {
        groupRepository.findById(id).ifPresent(group ->
        {
            for (Users user: userRepository.findAll()){
                for (GroupReference groupReference: user.getGroupReferenceList()){
                    if (groupReference.getGroupId().equals(group.getId())){
                        user.getGroupReferenceList().remove(groupReference);
                        userRepository.save(user);
                        break;
                    }
                }
            }
            groupRepository.delete(group);
        }
        );
    }
    public Groups findGroupById(UUID id) {
        return groupRepository.findById(id).orElse(null);
    }
}
