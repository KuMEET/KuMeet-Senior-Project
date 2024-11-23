package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventReference;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.example.KuMeetDemo.Dto.UserReference;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Groups;
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


@Data
@Service
public class UserEventService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    EventRepository eventRepository;

    public ResponseEntity<String> UserAddToEvent(UUID userId, UUID eventId){
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("User with given id %s could not found!", userId.toString())));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Event with given id %s could not found!", eventId.toString())));
        }

        if (events.getParticipantCount() >= events.getMaxCapacity()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body("Event capacity is full!");
        }

        UserReference userReference = new UserReference();
        userReference.setUserId(userId);
        userReference.setJoinAt(new Date(System.currentTimeMillis()));
        userReference.setRole("Member");

        List<UserReference> userReferenceList = events.getParticipants();
        if(userReferenceList == null){
            userReferenceList = new ArrayList<>();
        }
        else {
            for(UserReference userReferenceElement: userReferenceList){
                if(userReferenceElement.getUserId().equals(userId)){
                    return ResponseEntity
                            .status(HttpStatus.BAD_REQUEST)
                            .body(String.format("User with given id %s already exists!",userId));
                }
            }
        }



        userReferenceList.add(userReference);
        events.setParticipants(userReferenceList);
        events.setParticipantCount(events.getParticipantCount() + 1);

        EventReference eventReference = new EventReference();
        eventReference.setEventId(eventId);
        eventReference.setJoinAt(new Date(System.currentTimeMillis()));
        eventReference.setRole("Member");

        List<EventReference> eventReferenceList = user.getEventReferenceList();
        if(eventReferenceList == null){
            eventReferenceList = new ArrayList<>();
        }
        eventReferenceList.add(eventReference);
        user.setEventReferenceList(eventReferenceList);

        eventRepository.save(events);
        userRepository.save(user);

        return ResponseEntity.ok(String.format("User with given id %s added successfully to this event with id %s",
                userId, eventId));

    }

    public ResponseEntity<String> deleteUserFromEvent(UUID userId, UUID eventId) {
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given id %s could not be found!", userId));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with given id %s could not be found!", eventId));
        }

        List<UserReference> userReferenceList = events.getParticipants();
        if (userReferenceList == null || !userReferenceList.removeIf(ref -> ref.getUserId().equals(userId))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given id %s is not a member of the event %s!", userId, eventId));
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

        return ResponseEntity.ok(String.format("User with id %s successfully removed from event with id %s", userId, eventId));
    }

    public ResponseEntity<String> updateUserRoleInEvent(UUID userId, UUID eventId, String newRole) {
        Users user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("User with given id %s could not be found!", userId));
        }

        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with given id %s could not be found!", eventId));
        }

        List<UserReference> userReferenceList = events.getParticipants();
        if (userReferenceList == null || userReferenceList.stream().noneMatch(ref -> ref.getUserId().equals(userId))) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("User with given id %s is not a member of the group %s!", userId, eventId));
        }

        userReferenceList.forEach(ref -> {
            if (ref.getUserId().equals(userId)) {
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

        return ResponseEntity.ok(String.format("Role of user with id %s updated to %s in event with id %s", userId, newRole, eventId));
    }







}
