package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Model.Groups;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Service
public class GroupService {
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private UserRepository userRepository;

    public Groups createGroup(GroupDto groupDto) {
        Groups group = new Groups();
        group.setGroupName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        group.setCreatedAt(new Date(System.currentTimeMillis()));
        group.setId(UUID.randomUUID());
        return groupRepository.save(group);
    }
    public List<Groups> getAllGroups() {
        return groupRepository.findAll();
    }
    public Groups updateGroup(Groups updatedGroup) {
        Groups group = groupRepository.findById(updatedGroup.getId()).orElse(null);
        if (ObjectUtils.isEmpty(group)) {
            return null;
        }
        group.setGroupName(updatedGroup.getGroupName());
        group.setCapacity(updatedGroup.getCapacity());
        return groupRepository.save(group);
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
