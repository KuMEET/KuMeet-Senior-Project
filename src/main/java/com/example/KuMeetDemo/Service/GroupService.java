package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Model.Group;
import com.example.KuMeetDemo.Repository.GroupRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

@Data
@Service
public class GroupService {
    @Autowired
    private GroupRepository groupRepository;

    public Group createGroup(GroupDto groupDto) {
        Group group = new Group();
        group.setName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        return groupRepository.save(group);
    }

    public Group updateGroup(GroupDto groupDto) {
        Group group = groupRepository.findById(groupDto.getId());
        if (ObjectUtils.isEmpty(group)) {
            return null;
        }
        group.setName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        return groupRepository.save(group);
    }
    public void deleteGroup(GroupDto groupDto) {
        Group group = groupRepository.findById(groupDto.getId());
        groupRepository.delete(group);
    }

}