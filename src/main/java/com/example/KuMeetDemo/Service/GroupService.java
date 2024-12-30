package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.GroupDto;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.*;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.GroupRepository;
import com.example.KuMeetDemo.Repository.PhotoRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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
    @Autowired
    private PhotoRepository photoRepository;
    @Autowired
    private PhotoService photoService;

    public ResponseEntity<Groups> createGroup(GroupDto groupDto, MultipartFile photo,  String username) {
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

        if (photo != null && !photo.isEmpty()) {
                ResponseEntity<String> photoIdResponse = photoService.addPhoto(groupDto.getName() + " Photo", photo);
                if (photoIdResponse.getStatusCode().equals(HttpStatus.OK)) {
                    String photoId = photoIdResponse.getBody();
                    Photo photoInsert = photoRepository.findById(photoId).orElse(null);
                    if (photoInsert == null) {
                        return ResponseEntity.badRequest().body(null);
                    }
                    group.setPhoto(photoInsert);
                }
                else{
                    return ResponseEntity.badRequest().body(null);
                }
        }
        else{
            return ResponseEntity.badRequest().body(null);
        }

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
            List<GroupReference> groupReferenceList = existingUser.getGroupReferenceList();
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

    public ResponseEntity<List<Users>> ShowMembers(String groupId) {
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity.badRequest().body(null);
        }
        List<UserReference> participants = groups.getMembers();
        if (participants.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        List<Users> members = new ArrayList<>();
        participants.forEach(
                member -> {
                    if (member.getStatus().equals("Approved") && member.getRole().equals("Member")) {
                        Users user = userRepository.findById(member.getUserId()).orElse(null);
                        if (user != null) {
                            members.add(user);
                        }
                    }
                }
        );
        return ResponseEntity.ok(members);
    }

    public ResponseEntity<String> uploadGroupPhoto(String groupId, String imageId) {
        Photo photo = photoRepository.findById(imageId).orElse(null);
        if (photo == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Photo not found");
        }
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Event not found");
        }
        groups.setPhoto(photo);
        groupRepository.save(groups);
        return ResponseEntity.ok("Photo uploaded successfully for Event ID: " + groupId);
    }

}
