package com.example.KuMeetDemo.Service;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.Groups;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;



// 09230d94-3721-4374-b3e4-3a2f889ac4f2

@Data
@Service
public class UserGroupService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    GroupRepository groupRepository;
    public ResponseEntity<String> UserAddToGroup(UUID userId, UUID groupId){
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("User with given id %s could not found!", userId.toString())));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Group with given id %s could not found!", groupId.toString())));
        }

        if (group.getMemberCount() >= group.getCapacity()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("Group capacity is full!");
        }

        UserReference userReference = new UserReference();
        userReference.setUserId(userId);
        userReference.setJoinAt(new Date(System.currentTimeMillis()));
        userReference.setRole("Member");

        List<UserReference> userReferenceList = group.getMembers();
        if(userReferenceList == null){
            userReferenceList = new ArrayList<>();
        }
        else {
            for(UserReference userReferenceElement: userReferenceList){
                if(userReferenceElement.getUserId().equals(userId)){
                    return ResponseEntity
                            .status(HttpStatus.BAD_REQUEST)
                            .body(String.format("User with given id %s already exists!",userId));
                }
            }
        }

        userReferenceList.add(userReference);
        group.setMembers(userReferenceList);
        group.setMemberCount(group.getMemberCount() + 1);

        GroupReference groupReference = new GroupReference();
        groupReference.setGroupId(groupId);
        groupReference.setJoinAt(new Date(System.currentTimeMillis()));
        groupReference.setRole("Member");

        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        if(groupReferenceList == null){
            groupReferenceList = new ArrayList<>();
        }
        groupReferenceList.add(groupReference);
        user.setGroupReferenceList(groupReferenceList);

        groupRepository.save(group);
        userRepository.save(user);

        return ResponseEntity.ok(String.format("User with given id %s added successfully to this group with id %s",
                userId, groupId));
    }


    public ResponseEntity<String> deleteUserFromGroup(UUID userId, UUID groupId) {
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given id %s could not be found!", userId));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with given id %s could not be found!", groupId));
        }

        List<UserReference> userReferenceList = group.getMembers();
        if (userReferenceList == null || !userReferenceList.removeIf(ref -> ref.getUserId().equals(userId))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given id %s is not a member of the group %s!", userId, groupId));
        }

        group.setMembers(userReferenceList);
        group.setMemberCount(group.getMemberCount() - 1);
        groupRepository.save(group);

        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        if (groupReferenceList != null) {
            groupReferenceList.removeIf(ref -> ref.getGroupId().equals(groupId));
            user.setGroupReferenceList(groupReferenceList);
            userRepository.save(user);
        }

        return ResponseEntity.ok(String.format("User with id %s successfully removed from group with id %s", userId, groupId));
    }




    public ResponseEntity<String> updateUserRoleInGroup(UUID userId, UUID groupId, String newRole) {
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given id %s could not be found!", userId));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with given id %s could not be found!", groupId));
        }

        List<UserReference> userReferenceList = group.getMembers();
        if (userReferenceList == null || userReferenceList.stream().noneMatch(ref -> ref.getUserId().equals(userId))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given id %s is not a member of the group %s!", userId, groupId));
        }

        userReferenceList.forEach(ref -> {
            if (ref.getUserId().equals(userId)) {
                ref.setRole(newRole);
            }
        });
        group.setMembers(userReferenceList);
        groupRepository.save(group);

        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        if (groupReferenceList != null) {
            groupReferenceList.forEach(ref -> {
                if (ref.getGroupId().equals(groupId)) {
                    ref.setRole(newRole);
                }
            });
            user.setGroupReferenceList(groupReferenceList);
            userRepository.save(user);
        }

        return ResponseEntity.ok(String.format("Role of user with id %s updated to %s in group with id %s", userId, newRole, groupId));
    }
















}
