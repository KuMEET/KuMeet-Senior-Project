package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserGroupDto;
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
    public UserGroup save(UserGroupDto userGroupDto){
        UserGroup userGroup = new UserGroup();
        userGroup.setUserId(userGroupDto.getUserId());
        userGroup.setGroupId(userGroupDto.getGroupId());
        userGroup.setId(UUID.randomUUID());
        userGroup.setRole(userGroupDto.getRole());
        userGroup.setJoinTime(new Date(System.currentTimeMillis()));
        return userGroupRepository.save(userGroup);
    }
    public UserGroup update(UserGroupDto userGroupDto){
        if(!ObjectUtils.isEmpty(userGroupDto.getId())){
            UserGroup userGroup = userGroupRepository.findById(userGroupDto.getId());
            userGroup.setRole(userGroupDto.getRole());
            return userGroupRepository.save(userGroup);
        }
        return null;
    }
    public void delete(String id){
        userGroupRepository.deleteById(id);
    }
    // adding user to group
    public void addUserToGroup(String userName, String groupId) {
        User user = userRepository.findByName(userName);
        if (user == null) {
            System.out.println("User not found");
            return;
        }

        Group optionalGroup = groupRepository.findById(UUID.fromString(groupId));
        if (optionalGroup == null) {
            System.out.println("Group not found");
            return;
        }
        Optional<UserGroup> existingUserGroup = userGroupRepository.findByUserIdAndGroupId(user.getId(), optionalGroup.getId());
        if (existingUserGroup.isPresent()) {
            System.out.println("User is already a member of the group");
            return;
        }

        if (optionalGroup.getMemberCount() >= optionalGroup.getCapacity()) {
            System.out.println("Group capacity is full");
            return;
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
    }

    public void deleteUserFromGroup(String userName, String groupId) {
        User user = userRepository.findByName(userName);
        if (user == null) {
            System.out.println("User not found");
            return;
        }

        Group group = groupRepository.findById(UUID.fromString(groupId));
        if (group == null) {
            System.out.println("Group not found");
            return;
        }

        Optional<UserGroup> userGroupOptional = userGroupRepository.findByUserIdAndGroupId(user.getId(), group.getId());
        if (userGroupOptional.isEmpty()) {
            System.out.println("User is not a member of the group");
            return;
        }

        userGroupRepository.delete(userGroupOptional.get());

        group.setMemberCount(group.getMemberCount() - 1);
        groupRepository.save(group);

        System.out.println("User successfully removed from the group");
    }

}
