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

    public ResponseEntity<String> UserAddToGroup(String userName, UUID groupId) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("User with given userName %s could not found!", userName)));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Group with given id %s could not found!", groupId)));
        }

        if (group.getMemberCount() >= group.getCapacity()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("Group capacity is full!");
        }

        UserReference userReference = new UserReference();
        userReference.setUserId(user.getId());
        userReference.setJoinAt(new Date(System.currentTimeMillis()));
        userReference.setRole("Member");

        List<UserReference> userReferenceList = group.getMembers();
        if (userReferenceList == null) {
            userReferenceList = new ArrayList<>();
        } else {
            for (UserReference userReferenceElement : userReferenceList) {
                if (userReferenceElement.getUserId().equals(user.getId())) {
                    return ResponseEntity
                            .status(HttpStatus.BAD_REQUEST)
                            .body(String.format("User with given userName %s already exists!", userName));
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
        if (groupReferenceList == null) {
            groupReferenceList = new ArrayList<>();
        }
        groupReferenceList.add(groupReference);
        user.setGroupReferenceList(groupReferenceList);

        groupRepository.save(group);
        userRepository.save(user);

        return ResponseEntity.ok(String.format("User with given userName %s added successfully to this group with id %s",
                userName, groupId));
    }


    public ResponseEntity<String> deleteUserFromGroup(String userName, UUID groupId) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given userName %s could not be found!", userName));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with given id %s could not be found!", groupId));
        }

        List<UserReference> userReferenceList = group.getMembers();
        if (userReferenceList == null || !userReferenceList.removeIf(ref -> ref.getUserId().equals(user.getId()))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given userName %s is not a member of the group %s!", userName, groupId));
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

        return ResponseEntity.ok(String.format("User with userName %s successfully removed from group with id %s", userName, groupId));
    }


    public ResponseEntity<String> updateUserRoleInGroup(String userName, UUID groupId, String newRole) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given userName %s could not be found!", userName));
        }

        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with given id %s could not be found!", groupId));
        }

        List<UserReference> userReferenceList = group.getMembers();
        if (userReferenceList == null || userReferenceList.stream().noneMatch(ref -> ref.getUserId().equals(user.getId()))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given userName %s is not a member of the group %s!", userName, groupId));
        }

        userReferenceList.forEach(ref -> {
            if (ref.getUserId().equals(user.getId())) {
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

        return ResponseEntity.ok(String.format("Role of user with userName %s updated to %s in group with id %s", userName, newRole, groupId));
    }


    public ResponseEntity<List<Groups>> getGroupsByUsername(String userName) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        List<Groups> groups = new ArrayList<>();
        if (groupReferenceList != null) {
            for (GroupReference groupReference : groupReferenceList) {
                Groups group = groupRepository.findById(groupReference.getGroupId()).orElse(null);
                if (group == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
                }
                groups.add(group);
            }
        }
        return ResponseEntity.ok(groups);
    }
}
