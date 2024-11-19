package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Model.Group;
import com.example.KuMeetDemo.Repository.GroupRepository;
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

    public Group createGroup(GroupDto groupDto) {
        Group group = new Group();
        group.setName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        group.setCreatedAt(new Date(System.currentTimeMillis()));
        group.setId(UUID.randomUUID());
        return groupRepository.save(group);
    }
    public List<Group> getAllGroups() {
        return groupRepository.findAll();
    }
    public Group updateGroup(Group updatedGroup) {
        Group group = groupRepository.findById(String.valueOf(updatedGroup.getId())).orElse(null);
        if (ObjectUtils.isEmpty(group)) {
            return null;
        }
        group.setName(updatedGroup.getName());
        group.setCapacity(updatedGroup.getCapacity());
        return groupRepository.save(group);
    }
    public void deleteGroup(String id) {
        groupRepository.findById(id).ifPresent(group -> groupRepository.delete(group));
    }
    public Group findGroupById(String id) {
        return groupRepository.findById(id).orElse(null);
    }
}
