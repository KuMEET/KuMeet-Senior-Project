package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.UserGroupDto;
import com.example.KuMeetDemo.Model.UserGroup;
import com.example.KuMeetDemo.Repository.UserGroupRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Service
public class UserGroupService {
    @Autowired
    private UserGroupRepository userGroupRepository;

    public List<UserGroup> findAll(){
        return userGroupRepository.findAll();
    }

    public UserGroup findById(String id){
        UserGroup userGroup = userGroupRepository.findById(id).orElse(null);
        return userGroup;
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

}
