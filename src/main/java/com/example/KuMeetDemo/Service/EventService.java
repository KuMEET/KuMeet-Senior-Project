package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Dto.EventReference;
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

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private UserRepository userRepository;


    // create method
    public ResponseEntity<Events> createEvent(EventDto eventDto, String username) {
        // Check for null or missing fields in EventDto
        if (eventDto.getTitle() == null || eventDto.getTitle().isEmpty() ||
                eventDto.getDescription() == null || eventDto.getDescription().isEmpty() ||
                eventDto.getCapacity() <= 0 ||
                eventDto.getTime() == null ||
                eventDto.getLatitude() == null || eventDto.getLongitude() == null) {
            return ResponseEntity.badRequest().body(null); // 400 Bad Request
        }
        Users existingUser = userRepository.findByUserName(username);
        if(existingUser == null){
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


        UserReference userInfo = new UserReference();
        userInfo.setUserId(existingUser.getId());
        userInfo.setRole("Admin");
        userInfo.setJoinAt(new Date(System.currentTimeMillis()));
        try {
            Events savedEvent = eventRepository.save(event);
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

//    public Events updateEvent(Events updatedEvent) {
//        Events event = eventRepository.findById(updatedEvent.getId()).orElse(null);
//        if (event == null) {
//            return null;
//        }
//        event.setEventTitle(updatedEvent.getEventTitle());
//        event.setEventType(updatedEvent.getEventType());
//        event.setEventDescription(updatedEvent.getEventDescription());
//        event.setMaxCapacity(updatedEvent.getMaxCapacity());
//        event.setEventTime(updatedEvent.getEventTime());
//        return eventRepository.save(event);
//    }
    // event silinince user listesindeki eventreference da silinmeli
    public void deleteEvent(UUID id) {
        eventRepository.findById(id).ifPresent(event ->
                {
                    for (Users user: userRepository.findAll()){
                        for (EventReference eventReference: user.getEventReferenceList()){
                            if (eventReference.getEventId().equals(event.getId())){
                                user.getGroupReferenceList().remove(eventReference);
                                userRepository.save(user);
                                break;
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
}
