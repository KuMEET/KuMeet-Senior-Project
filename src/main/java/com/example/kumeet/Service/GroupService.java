package com.example.kumeet.Service;

import com.example.kumeet.Dto.GroupDto;
import com.example.kumeet.Dto.GroupReference;
import com.example.kumeet.Dto.UserReference;
import com.example.kumeet.Model.Categories;
import com.example.kumeet.Model.Events;
import com.example.kumeet.Model.Groups;
import com.example.kumeet.Model.Users;
import com.example.kumeet.Repository.EventRepository;
import com.example.kumeet.Repository.GroupRepository;
import com.example.kumeet.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Data
@Service
public class GroupService {
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EventRepository eventRepository;

    public ResponseEntity<Groups> createGroup(GroupDto groupDto, String username) {
        // Validate input
        if (groupDto.getName() == null || groupDto.getName().isEmpty() || groupDto.getVisibility() == null || groupDto.getCategories().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        if (groupDto.getCapacity() <= 0) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        // tüm grupları getircem isimleri aynı olabilir
        //

        Users existingUser = userRepository.findByUserName(username);
        if (existingUser == null) {
            return ResponseEntity.badRequest().body(null);
        }

        Groups group = new Groups();
        group.setGroupName(groupDto.getName());
        group.setCapacity(groupDto.getCapacity());
        group.setCreatedAt(new Date(System.currentTimeMillis()));
        group.setId(UUID.randomUUID());
        group.setVisibility(groupDto.getVisibility());

        Arrays.stream(Categories.values())
                .filter(x -> x.name.equals(groupDto.getCategories()))
                .findFirst()
                .ifPresent(group::setCategories);

        List<UserReference> groupMembers = new ArrayList<>();
        UserReference userInfo = new UserReference();
        userInfo.setUserId(existingUser.getId());
        userInfo.setRole("Admin");
        userInfo.setStatus("Approved");
        userInfo.setJoinAt(new Date(System.currentTimeMillis()));
        groupMembers.add(userInfo);
        group.setMembers(groupMembers);
        try {
            Groups savedGroup = groupRepository.save(group);
            List<GroupReference> groupReferenceList = new ArrayList<>();
            GroupReference groupReference = new GroupReference();
            groupReference.setRole("Admin");
            groupReference.setGroupId(group.getId());
            groupReference.setJoinAt(group.getCreatedAt());
            groupReference.setStatus("Approved");
            groupReferenceList.add(groupReference);
            existingUser.setGroupReferenceList(groupReferenceList);
            userRepository.save(existingUser);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedGroup); // 201 Created
        } catch (Exception e) {
            // Log the exception (using your preferred logging framework)
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 500 Internal Server Error
        }
    }

    public List<Groups> getAllGroups() {
        return groupRepository.findAll();
    }

    public ResponseEntity<Groups> updateGroup(String groupId, GroupDto groupDto) {
        UUID newId = UUID.fromString(groupId);
        if (groupDto.getName() == null || groupDto.getCapacity() <= 0 || groupDto.getVisibility() == null || groupDto.getCategories().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        Groups groups = groupRepository.findById(newId).orElse(null);
        if (groups != null) {
            groups.setGroupName(groupDto.getName());
            groups.setCapacity(groupDto.getCapacity());
            Arrays.stream(Categories.values())
                    .filter(x -> x.name.equals(groupDto.getCategories()))
                    .findFirst()
                    .ifPresent(groups::setCategories);
            groups.setVisibility(groupDto.getVisibility());
            groupRepository.save(groups);
            return ResponseEntity.ok(groups);
        }
        return ResponseEntity.badRequest().body(null);
    }

    // herbir relation icin cascade deletingi manüel yapmalıyız
    // eventin baglı oldugu group silinince eventin relation oldugu groupu da sil
    public void deleteGroup(UUID id) {
        groupRepository.findById(id).ifPresent(group ->
                {
                    for (Users user : userRepository.findAll()) {
                        if (user.getGroupReferenceList() != null && !user.getGroupReferenceList().isEmpty()) {
                            for (GroupReference groupReference : user.getGroupReferenceList()) {
                                if (groupReference.getGroupId().equals(group.getId())) {
                                    user.getGroupReferenceList().remove(groupReference);
                                    userRepository.save(user);
                                    break;
                                }
                            }
                        }
                    }


                    List<UUID> eventsList = group.getEventsList();
                    if (!eventsList.isEmpty()) {
                        eventsList.forEach(
                                element -> {
                                    Events events = eventRepository.findById(element).orElse(null);
                                    events.setGroupID(null);
                                    eventRepository.save(events);
                                }
                        );
                    }
                    groupRepository.delete(group);
                }
        );
    }

    public Groups findGroupById(UUID id) {
        return groupRepository.findById(id).orElse(null);
    }

    public ResponseEntity<List<Groups>> FilterGroupsBasedOnCategories(String category) {
        Optional<Categories> optionalCategory = Arrays.stream(Categories.values())
                .filter(x -> x.name.equals(category))
                .findFirst();

        if (optionalCategory.isPresent()) {
            Categories categories = optionalCategory.get();
            return ResponseEntity.ok(groupRepository.findByCategories(categories));
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);


    }
}
