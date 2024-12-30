package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventReference;
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
import java.util.stream.Collectors;


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

        GroupReference groupReference = new GroupReference();
        groupReference.setGroupId(groupId);
        groupReference.setRole("Member");


        if (group.isVisibility()) {
            userReference.setStatus("Approved");
            groupReference.setStatus("Approved");
            userReference.setJoinAt(new Date(System.currentTimeMillis()));
            group.setMemberCount(group.getMemberCount() + 1);
            groupReference.setJoinAt(new Date(System.currentTimeMillis()));

        } else {
            userReference.setStatus("Pending");
            groupReference.setStatus("Pending");
            groupReference.setJoinAt(new Date());
            userReference.setJoinAt(new Date());

        }



        userReferenceList.add(userReference);
        group.setMembers(userReferenceList);

        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        if (groupReferenceList == null) {
            groupReferenceList = new ArrayList<>();
        }
        groupReferenceList.add(groupReference);
        user.setGroupReferenceList(groupReferenceList);

        groupRepository.save(group);
        userRepository.save(user);
        String message = group.isVisibility()
                ? String.format("User %s added successfully to public group %s.", userName, groupId)
                : String.format("User %s requested to join private group %s. Awaiting admin approval.", userName, groupId);
        return ResponseEntity.ok(message);
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
                if (groupReference.getStatus().equals("Pending")){
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
                }
                if (group == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
                }
                groups.add(group);
            }
        }
        return ResponseEntity.ok(groups);
    }

    public ResponseEntity<List<Groups>> getGroupsForAdmin(String userName) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
        List<GroupReference> groupReferenceList = user.getGroupReferenceList();
        List<Groups> groups = new ArrayList<>();
        if (groupReferenceList != null) {
            for (GroupReference groupReference : groupReferenceList) {
                Groups group = groupRepository.findById(groupReference.getGroupId()).orElse(null);
                String role = groupReference.getRole();
                if (group == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
                }
                if(role.equals("Admin")){
                    groups.add(group);
                }
            }
        }
        if(groups.isEmpty()){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(groups);
    }

    public ResponseEntity<List<Users>> getAdminsForGroup(String groupId) {
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
        List<UserReference> userReferenceList = groups.getMembers();
        List<Users> users = new ArrayList<>();
        if (userReferenceList != null) {
            for (UserReference userReference : userReferenceList) {
                String role = userReference.getRole();
                if (role.equals("Admin")) {
                    Users user = userRepository.findById(userReference.getUserId()).orElse(null);
                    if (user != null) {
                        users.add(user);
                    }
                }
            }
        }
        if (users.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(users);
    }

    public ResponseEntity<List<UserReference>> viewPendingUsersForGroup(UUID groupId) {
        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        List<UserReference> pendingUsers = group.getMembers().stream()
                .filter(member -> "Pending".equals(member.getStatus()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(pendingUsers);
    }



    public ResponseEntity<String> approveUserRequestForGroup(UUID groupId, UUID userId) {
        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with id %s not found!", groupId));
        }

        UserReference userReference = group.getMembers().stream()
                .filter(member -> member.getUserId().equals(userId) && "Pending".equals(member.getStatus()))
                .findFirst()
                .orElse(null);

        if (userReference == null) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("No pending user request found for this group!");
        }

        userReference.setStatus("Approved");
        userReference.setJoinAt(new Date(System.currentTimeMillis()));
        group.setMemberCount(group.getMemberCount() + 1);

        Users user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.getGroupReferenceList().stream()
                    .filter(gr -> gr.getGroupId().equals(groupId) && "Pending".equals(gr.getStatus()))
                    .forEach(gr -> {
                        gr.setStatus("Approved");
                        gr.setJoinAt(new Date(System.currentTimeMillis()));
                    });
            userRepository.save(user);
        }

        groupRepository.save(group);
        return ResponseEntity.ok(String.format("User with id %s approved for group %s.", userId, groupId));
    }



    public ResponseEntity<String> rejectUserRequestForGroup(UUID groupId, UUID userId) {
        Groups group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with id %s not found!", groupId));
        }

        List<UserReference> members = group.getMembers();
        UserReference userReference = members.stream()
                .filter(member -> member.getUserId().equals(userId) && "Pending".equals(member.getStatus()))
                .findFirst()
                .orElse(null);

        if (userReference == null) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("No pending user request found for this group!");
        }

        members.remove(userReference);
        group.setMembers(members);

        Users user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.getGroupReferenceList().removeIf(gr -> gr.getGroupId().equals(groupId) && "Pending".equals(gr.getStatus()));
            userRepository.save(user);
        }

        groupRepository.save(group);
        return ResponseEntity.ok(String.format("User with id %s rejected for group %s.", userId, groupId));
    }





}
