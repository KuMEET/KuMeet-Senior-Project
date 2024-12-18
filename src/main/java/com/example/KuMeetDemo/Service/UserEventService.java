package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventReference;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;


@Data
@Service
public class UserEventService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    EventRepository eventRepository;

    public ResponseEntity<String> UserAddToEvent(String userName, UUID eventId) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("User with given userName %s could not found!", userName)));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Event with given id %s could not found!", eventId)));
        }

        if (events.getParticipantCount() >= events.getMaxCapacity()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("Event capacity is full!");
        }
        UserReference userReference = new UserReference();
        userReference.setUserId(user.getId());
        userReference.setRole("Member");

        List<UserReference> userReferenceList = events.getParticipants();
        if (userReferenceList == null) {
            userReferenceList = new ArrayList<>();
        } else {
            for (UserReference userReferenceElement : userReferenceList) {
                if (userReferenceElement.getUserId().equals(user.getId())) {
                    return ResponseEntity
                            .status(HttpStatus.BAD_REQUEST)
                            .body(String.format("User with given userName %s already exists!", userName));
                }
            }
        }

        EventReference eventReference = new EventReference();
        eventReference.setEventId(eventId);
        eventReference.setRole("Member");

        if (events.isVisibility()) {
            userReference.setStatus("Approved");
            eventReference.setStatus("Approved");
            userReference.setJoinAt(new Date(System.currentTimeMillis()));
            events.setParticipantCount(events.getParticipantCount() + 1);
            eventReference.setJoinAt(new Date(System.currentTimeMillis()));

        } else {
            userReference.setStatus("Pending");
            eventReference.setStatus("Pending");
            eventReference.setJoinAt(new Date());
            userReference.setJoinAt(new Date());

        }

        userReferenceList.add(userReference);
        events.setParticipants(userReferenceList);


        List<EventReference> eventReferenceList = user.getEventReferenceList();
        if (eventReferenceList == null) {
            eventReferenceList = new ArrayList<>();
        }
        eventReferenceList.add(eventReference);
        user.setEventReferenceList(eventReferenceList);

        eventRepository.save(events);
        userRepository.save(user);
        String message = events.isVisibility()
                ? String.format("User %s added successfully to public event %s.", userName, eventId)
                : String.format("User %s requested to join private event %s. Awaiting admin approval.", userName, eventId);
        return ResponseEntity.ok(message);

    }

    public ResponseEntity<String> deleteUserFromEvent(String userName, UUID eventId) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given userName %s could not be found!", userName));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with given id %s could not be found!", eventId));
        }

        List<UserReference> userReferenceList = events.getParticipants();
        if (userReferenceList == null || !userReferenceList.removeIf(ref -> ref.getUserId().equals(user.getId()))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given userName %s is not a member of the event %s!", userName, eventId));
        }

        events.setParticipants(userReferenceList);
        events.setParticipantCount(events.getParticipantCount() - 1);
        eventRepository.save(events);

        List<EventReference> eventReferenceList = user.getEventReferenceList();
        if (eventReferenceList != null) {
            eventReferenceList.removeIf(ref -> ref.getEventId().equals(eventId));
            user.setEventReferenceList(eventReferenceList);
            userRepository.save(user);
        }

        return ResponseEntity.ok(String.format("User with userName %s successfully removed from event with id %s", userName, eventId));
    }

    public ResponseEntity<String> updateUserRoleInEvent(String userName, UUID eventId, String newRole) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given userName %s could not be found!", userName));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with given id %s could not be found!", eventId));
        }

        List<UserReference> userReferenceList = events.getParticipants();
        if (userReferenceList == null || userReferenceList.stream().noneMatch(ref -> ref.getUserId().equals(user.getId()))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given userName %s is not a member of the group %s!", userName, eventId));
        }

        userReferenceList.forEach(ref -> {
            if (ref.getUserId().equals(user.getId())) {
                ref.setRole(newRole);
            }
        });
        events.setParticipants(userReferenceList);
        eventRepository.save(events);

        List<EventReference> eventReferenceList = user.getEventReferenceList();
        if (eventReferenceList != null) {
            eventReferenceList.forEach(ref -> {
                if (ref.getEventId().equals(eventId)) {
                    ref.setRole(newRole);
                }
            });
            user.setEventReferenceList(eventReferenceList);
            userRepository.save(user);
        }

        return ResponseEntity.ok(String.format("Role of user with userName %s updated to %s in event with id %s", userName, newRole, eventId));
    }


    public ResponseEntity<List<Events>> getEventsByUsername(String userName) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
        List<EventReference> eventReferenceList = user.getEventReferenceList();
        List<Events> events = new ArrayList<>();
        if (eventReferenceList != null) {
            for (EventReference eventReference : eventReferenceList) {
                if (eventReference.getStatus().equals("Pending")) {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
                }
                Events event = eventRepository.findById(eventReference.getEventId()).orElse(null);
                if (event == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
                }
                events.add(event);
            }
        }
        return ResponseEntity.ok(events);
    }

    public ResponseEntity<List<Events>> getEventsForAdmin(String userName) {
        Users user = userRepository.findByUserName(userName);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
        List<EventReference> eventReferenceList = user.getEventReferenceList();
        List<Events> events = new ArrayList<>();
        if (eventReferenceList != null) {
            for (EventReference eventReference : eventReferenceList) {
                Events event = eventRepository.findById(eventReference.getEventId()).orElse(null);
                String role = eventReference.getRole();
                if (event == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
                }
                if (role.equals("Admin")) {
                    events.add(event);
                }

            }
        }
        if (events.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(events);
    }


    public ResponseEntity<String> approveUserRequest(UUID eventId, UUID userId) {
        Events event = eventRepository.findById(eventId).orElse(null);
        if (event == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with id %s not found!", eventId));
        }

        UserReference userReference = event.getParticipants().stream()
                .filter(p -> p.getUserId().equals(userId) && p.getStatus().equals("pending"))
                .findFirst()
                .orElse(null);

        if (userReference == null) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("No pending user request found for this event!");
        }

        userReference.setStatus("approved");
        userReference.setJoinAt(new Date(System.currentTimeMillis()));
        event.setParticipantCount(event.getParticipantCount() + 1);

        Users user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.getEventReferenceList().stream()
                    .filter(e -> e.getEventId().equals(eventId) && e.getStatus().equals("pending"))
                    .forEach(e -> {
                        e.setStatus("approved");
                        e.setJoinAt(new Date(System.currentTimeMillis()));
                    });
            userRepository.save(user);
        }

        eventRepository.save(event);
        return ResponseEntity.ok(String.format("User with id %s approved for event %s.", userId, eventId));
    }

    public ResponseEntity<List<UserReference>> viewPendingUsers(UUID eventId) {
        Events event = eventRepository.findById(eventId).orElse(null);
        if (event == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        List<UserReference> pendingUsers = event.getParticipants().stream()
                .filter(p -> p.getStatus().equals("pending"))
                .collect(Collectors.toList());

        return ResponseEntity.ok(pendingUsers);
    }


    public ResponseEntity<String> rejectUserRequest(UUID eventId, UUID userId) {
        Events event = eventRepository.findById(eventId).orElse(null);
        if (event == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with id %s not found!", eventId));
        }

        List<UserReference> participants = event.getParticipants();
        UserReference userReference = participants.stream()
                .filter(p -> p.getUserId().equals(userId) && p.getStatus().equals("pending"))
                .findFirst()
                .orElse(null);

        if (userReference == null) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("No pending user request found for this event!");
        }

        participants.remove(userReference);
        event.setParticipants(participants);

        Users user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.getEventReferenceList().removeIf(e -> e.getEventId().equals(eventId) && e.getStatus().equals("pending"));
            userRepository.save(user);
        }

        eventRepository.save(event);
        return ResponseEntity.ok(String.format("User with id %s rejected for event %s.", userId, eventId));
    }
}
