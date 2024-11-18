package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserDto;
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
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserGroupRepository userGroupRepository;
    @Autowired
    private GroupRepository groupRepository;

    // create method
    public User registerUser(UserDto userDto) {
        User user = new User();
        user.setName(userDto.getUserName());
        user.setEMail(userDto.getEmail());
        user.setPassWord(userDto.getPassword());
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setId(UUID.randomUUID());
        return userRepository.save(user);
    }
    public User findUserByUserId(UUID userId) {
        User user = userRepository.findById(userId);
        if (ObjectUtils.isEmpty(user)) {
            return null;
        }
        return user;
    }


    public User updateUser(UserDto userDto) {
        if(!ObjectUtils.isEmpty(userDto)){
            Optional<User> userOption =  userRepository.findById(userDto.getUserName());
            if(userOption.isPresent()){
                User user = userOption.get();
                user.setName(userDto.getUserName());
                user.setEMail(userDto.getEmail());
                user.setPassWord(userDto.getPassword());
                user.setCreatedAt(new Date(System.currentTimeMillis()));
                user = userRepository.save(user);
                return user;
            }
        }
        return null;

    }

    public User deleteUser(UUID userId) {
        User user = userRepository.findById(userId);
        if(!ObjectUtils.isEmpty(user)){
            userRepository.delete(user);
            return user;
        }
        return null;
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

    // delete user from group
    public void deleteUserFromGroup(String userName, String groupId) {
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

        Optional<UserGroup> userGroupOptional = userGroupRepository.findByUserIdAndGroupId(user.getId(), optionalGroup.getId());
        if (userGroupOptional.isEmpty()) {
            System.out.println("User is not a member of the group");
            return;
        }

        userGroupRepository.delete(userGroupOptional.get());

        optionalGroup.setMemberCount(optionalGroup.getMemberCount() - 1);
        groupRepository.save(optionalGroup);

        System.out.println("User successfully removed from the group");
    }
    public List<User> getUsersByName(String name) {
        return userRepository.findAllByName(name);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }














}
