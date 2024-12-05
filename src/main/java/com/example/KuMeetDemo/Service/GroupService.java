package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.Events;
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

import java.util.*;

@Data
@Service
public class GroupService {
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<Groups> createGroup(GroupDto groupDto, String username) {
        // Validate input
        if (groupDto.getName() == null || groupDto.getName().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        if (groupDto.getCapacity() <= 0) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        // tüm grupları getircem isimleri aynı olabilir
        //

        Users existingUser = userRepository.findByUserName(username);
        if(existingUser == null){
            return ResponseEntity.badRequest().body(null);
        }

        Groups group = new Groups();
        group.setGroupName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        group.setCreatedAt(new Date(System.currentTimeMillis()));
        group.setId(UUID.randomUUID());

        List<UserReference> groupMembers = new ArrayList<>();
        UserReference userInfo = new UserReference();
        userInfo.setUserId(existingUser.getId());
        userInfo.setRole("Admin");
        userInfo.setJoinAt(new Date(System.currentTimeMillis()));
        groupMembers.add(userInfo);
        group.setMembers(groupMembers);
        try {
            Groups savedGroup = groupRepository.save(group);
            List<GroupReference> groupReferenceList = new ArrayList<>();
            GroupReference groupReference = new GroupReference();
            groupReference.setRole("Admin");
            groupReference.setGroupId(group.getId());
            groupReference.setJoinAt(group.getCreatedAt());
            groupReferenceList.add(groupReference);
            existingUser.setGroupReferenceList(groupReferenceList);
            userRepository.save(existingUser);
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
    public ResponseEntity<Groups> updateGroup(UUID id, GroupDto groupDto) {
        if (groupDto.getName() == null || groupDto.getCapacity() <= 0 ) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        Groups groups = groupRepository.findById(id).orElse(null);
        if (groups != null) {
            groups.setGroupName(groupDto.getName());
            groups.setCapacity(groupDto.getCapacity());
            groupRepository.save(groups);
            return ResponseEntity.ok(groups);
        }
        return ResponseEntity.badRequest().body(null);
    }

    // herbir relation icin cascade deletingi manüel yapmalıyız
    public void deleteGroup(UUID id) {
        groupRepository.findById(id).ifPresent(group ->
        {
            for (Users user: userRepository.findAll()){
                if(user.getGroupReferenceList()!=null && !user.getGroupReferenceList().isEmpty()){
                    for (GroupReference groupReference: user.getGroupReferenceList()){
                        if (groupReference.getGroupId().equals(group.getId())){
                            user.getGroupReferenceList().remove(groupReference);
                            userRepository.save(user);
                            break;
                        }
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
