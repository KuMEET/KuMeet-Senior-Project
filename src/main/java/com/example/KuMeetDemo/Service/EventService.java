package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Dto.EventReference;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.UserRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    public Events createEvent(EventDto eventDto) {
        Events event = new Events();
        event.setId(UUID.randomUUID());
        event.setEventTitle(eventDto.getName());
        event.setEventType(eventDto.getType());
        event.setEventDescription(eventDto.getDescription());
        event.setMaxCapacity(eventDto.getCapacity());
        event.setEventTime(eventDto.getTime());
        return eventRepository.save(event);
    }
    // read method
    public List<Events> getAllEvents() {
        return eventRepository.findAll();
    }

    public Events updateEvent(Events updatedEvent) {
        Events event = eventRepository.findById(updatedEvent.getId()).orElse(null);
        if (event == null) {
            return null;
        }
        event.setEventTitle(updatedEvent.getEventTitle());
        event.setEventType(updatedEvent.getEventType());
        event.setEventDescription(updatedEvent.getEventDescription());
        event.setMaxCapacity(updatedEvent.getMaxCapacity());
        event.setEventTime(updatedEvent.getEventTime());
        return eventRepository.save(event);
    }
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
