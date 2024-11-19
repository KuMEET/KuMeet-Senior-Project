package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Model.Group;
import com.example.KuMeetDemo.Model.User;
import com.example.KuMeetDemo.Model.UserGroup;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserGroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Data
@Service
public class UserGroupService {
    @Autowired
    private UserGroupRepository userGroupRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private GroupRepository groupRepository;

    public List<UserGroup> findAll(){
        return userGroupRepository.findAll();
    }
    public UserGroup findById(String id){
        return userGroupRepository.findById(id).orElse(null);
    }
    public UserGroup update(UserGroup updateUserGroup){
        UserGroup userGroup = userGroupRepository.findById(String.valueOf(updateUserGroup.getId())).orElse(null);
        if(ObjectUtils.isEmpty(userGroup)){
            return null;
        }
        userGroup.setRole(updateUserGroup.getRole());
        userGroupRepository.save(userGroup);
        return userGroup;
    }
    public void delete(String id){
        userGroupRepository.deleteById(id);
    }
    // adding user to group
    public UserGroup addUserToGroup(String userName, String groupId) {
        User user = userRepository.findByName(userName);
        if (user == null) {
            System.out.println("User not found");
            return null;
        }

        Group optionalGroup = groupRepository.findById(groupId).orElse(null);
        if (optionalGroup == null) {
            System.out.println("Group not found");
            return null;
        }
        Optional<UserGroup> existingUserGroup = userGroupRepository.findByUserIdAndGroupId(user.getId(), optionalGroup.getId());
        if (existingUserGroup.isPresent()) {
            System.out.println("User is already a member of the group");
            return null;
        }

        if (optionalGroup.getMemberCount() >= optionalGroup.getCapacity()) {
            System.out.println("Group capacity is full");
            return null;
        }

        // Create a new UserGroup entry
        UserGroup userGroup = new UserGroup();
        userGroup.setId(UUID.randomUUID());
        userGroup.setUserId(user.getId());
        userGroup.setGroupId(optionalGroup.getId());
        userGroup.setJoinTime(new Date());
        userGroup.setRole("Member");

        userGroupRepository.save(userGroup);

        optionalGroup.setMemberCount(optionalGroup.getMemberCount() + 1);
        groupRepository.save(optionalGroup);

        System.out.println("User successfully added to the group");
        return userGroup;
    }

    public UserGroup deleteUserFromGroup(String userName, String groupId) {
        User user = userRepository.findByName(userName);
        if (user == null) {
            System.out.println("User not found");
            return null;
        }

        Group group = groupRepository.findById(groupId).orElse(null);
        if (group == null) {
            System.out.println("Group not found");
            return null;
        }

        UserGroup userGroup = userGroupRepository.findByUserIdAndGroupId(user.getId(), group.getId()).orElse(null);
        if (userGroup == null) {
            System.out.println("User is not a member of the group");
            return null;
        }
        userGroupRepository.delete(userGroup);
        group.setMemberCount(group.getMemberCount() - 1);
        System.out.println("User successfully removed from the group");
        return userGroup;
    }

}
