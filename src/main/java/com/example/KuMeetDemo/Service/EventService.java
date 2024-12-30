package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Dto.EventReference;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Data
@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private GroupRepository groupRepository;
    @Autowired
    private PhotoRepository photoRepository;


    // create method
    public ResponseEntity<Events> createEvent(EventDto eventDto, String username) {
        // Check for null or missing fields in EventDto
        if (eventDto.getTitle() == null || eventDto.getTitle().isEmpty() ||
                eventDto.getDescription() == null || eventDto.getDescription().isEmpty() ||
                eventDto.getCapacity() <= 0 ||
                eventDto.getTime() == null ||
                eventDto.getLatitude() == null || eventDto.getLongitude() == null || eventDto.getVisibility() == null || eventDto.getCategories().isEmpty()) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        Users existingUser = userRepository.findByUserName(username);
        if (existingUser == null) {
            return ResponseEntity.badRequest().body(null);
        }
        // Create the event object
        Events event = new Events();
        event.setId(UUID.randomUUID());
        event.setEventTitle(eventDto.getTitle());
        event.setEventDescription(eventDto.getDescription());
        event.setMaxCapacity(eventDto.getCapacity());
        event.setEventTime(eventDto.getTime());
        event.setCreatedAt(new Date(System.currentTimeMillis()));
        event.setLatitude(eventDto.getLatitude());
        event.setLongitude(eventDto.getLongitude());
        event.setVisibility(eventDto.getVisibility());
        Arrays.stream(Categories.values())
                .filter(x -> x.name.equals(eventDto.getCategories()))
                .findFirst()
                .ifPresent(event::setCategories);

        List<UserReference> eventMembers = new ArrayList<>();
        UserReference userInfo = new UserReference();
        userInfo.setUserId(existingUser.getId());
        userInfo.setRole("Admin");
        userInfo.setJoinAt(new Date(System.currentTimeMillis()));
        userInfo.setStatus("Approved");
        eventMembers.add(userInfo);
        event.setParticipants(eventMembers);

        try {
            Events savedEvent = eventRepository.save(event);

            List<EventReference> eventReferenceList = existingUser.getEventReferenceList();
            EventReference eventReference = new EventReference();
            eventReference.setEventId(event.getId());
            eventReference.setJoinAt(event.getEventTime());
            eventReference.setRole("Admin");
            eventReference.setStatus("Approved");
            eventReferenceList.add(eventReference);
            existingUser.setEventReferenceList(eventReferenceList);
            userRepository.save(existingUser);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedEvent); // 201 Created
        } catch (Exception e) {
            // Log the exception (using your preferred logging framework)
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 500 Internal Server Error
        }
        // Save the event


    }

    // read method
    public List<Events> getAllEvents() {
        return eventRepository.findAll();
    }

    // eğer event bir groupa baglı ise o zaman silinince groupun listesinden de sil
    public void deleteEvent(UUID id) {
        eventRepository.findById(id).ifPresent(event ->
                {
                    for (Users user : userRepository.findAll()) {
                        if (user.getEventReferenceList() != null && !user.getEventReferenceList().isEmpty()) {
                            for (EventReference eventReference : user.getEventReferenceList()) {
                                if (eventReference.getEventId().equals(event.getId())) {
                                    user.getEventReferenceList().remove(eventReference);
                                    userRepository.save(user);
                                    break;
                                }
                            }
                        }

                    }
                    for (Groups groups : groupRepository.findAll()) {
                        if (groups.getEventsList() != null && !groups.getEventsList().isEmpty()) {
                            for (UUID eventID : groups.getEventsList()) {
                                if (eventID.equals(id)) {
                                    groups.getEventsList().remove(eventID);
                                    groupRepository.save(groups);
                                    break;
                                }
                            }
                        }

                    }

                    eventRepository.delete(event);
                }
        );
    }

    public Events getEvent(UUID id) {
        return eventRepository.findById(id).orElse(null);
    }

    public ResponseEntity<Events> updateEvent(String eventId, EventDto eventDto) {
        UUID newId = UUID.fromString(eventId);
        if (eventDto.getTitle() == null || eventDto.getTitle().isEmpty() ||
                eventDto.getDescription() == null || eventDto.getDescription().isEmpty() ||
                eventDto.getCapacity() <= 0 ||
                eventDto.getTime() == null ||
                eventDto.getLatitude() == null || eventDto.getLongitude() == null || eventDto.getCategories().isEmpty() || eventDto.getVisibility() == null) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }

        Events event = eventRepository.findById(newId).orElse(null);
        if (event != null) {
            event.setEventTitle(eventDto.getTitle());
            event.setEventDescription(eventDto.getDescription());
            event.setMaxCapacity(eventDto.getCapacity());
            event.setEventTime(eventDto.getTime());
            event.setLatitude(eventDto.getLatitude());
            event.setLongitude(eventDto.getLongitude());
            event.setVisibility(eventDto.getVisibility());
            Arrays.stream(Categories.values())
                    .filter(x -> x.name.equals(eventDto.getCategories()))
                    .findFirst()
                    .ifPresent(event::setCategories);
            eventRepository.save(event);
            return ResponseEntity.ok(event);
        }
        return ResponseEntity.badRequest().body(null);
    }

    public ResponseEntity<List<Events>> FilterEventsBasedOnCategories(String category) {
        Optional<Categories> optionalCategory = Arrays.stream(Categories.values())
                .filter(x -> x.name.equals(category))
                .findFirst();

        if (optionalCategory.isPresent()) {
            Categories categories = optionalCategory.get();
            return ResponseEntity.ok(eventRepository.findByCategories(categories));
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
    }

    public ResponseEntity<List<Users>> ShowMembers(String eventId) {
        UUID eventID = UUID.fromString(eventId);
        Events events = eventRepository.findById(eventID).orElse(null);
        if (events == null) {
            return ResponseEntity.badRequest().body(null);
        }
        List<UserReference> participants = events.getParticipants();
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

    public ResponseEntity<Users> ShowAdmin(String eventId) {
        UUID eventID = UUID.fromString(eventId);
        Events events = eventRepository.findById(eventID).orElse(null);
        if (events == null) {
            return ResponseEntity.badRequest().body(null);
        }
        List<UserReference> participants = events.getParticipants();
        if (participants.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        for (UserReference member : participants) {
            if (member.getStatus().equals("Approved") && member.getRole().equals("Admin")) {
                Users users = userRepository.findById(member.getUserId()).orElse(null);
                if (users != null) {
                    return ResponseEntity.ok(users);
                }
            }
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
    }

    public ResponseEntity<String> uploadEventPhoto(String eventId,String imageId) {
        Photo photo = photoRepository.findById(imageId).orElse(null);
        if (photo == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Photo not found");
        }
        UUID eventID = UUID.fromString(eventId);
        Events event = eventRepository.findById(eventID).orElse(null);
        if (event == null){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Event not found");
        }

        event.setPhoto(photo);
        eventRepository.save(event);
        return ResponseEntity.ok("Photo uploaded successfully for Event ID: " + eventId);
    }




}
