package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Model.Event;
import com.example.KuMeetDemo.Repository.EventRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Data
@Service
public class EventService {
    @Autowired
    private EventRepository eventRepository;


    // create method
    public Event createEvent(EventDto eventDto) {
        Event event = new Event();
        event.setId(UUID.randomUUID());
        event.setName(eventDto.getName());
        event.setType(eventDto.getType());
        event.setDescription(eventDto.getDescription());
        event.setLocationId(eventDto.getLocationId());
        event.setCapacity(eventDto.getCapacity());
        event.setEventTime(eventDto.getTime());
        return eventRepository.save(event);
    }
    // read method

    public Event updateEvent(Event eventDto) {
        Event event = eventRepository.findById(eventDto.getId());
        event.setName(eventDto.getName());
        event.setType(eventDto.getType());
        event.setDescription(eventDto.getDescription());
        event.setLocationId(eventDto.getLocationId());
        event.setCapacity(eventDto.getCapacity());
        event.setEventTime(eventDto.getEventTime());
        return eventRepository.save(event);
    }
    public void deleteEvent(UUID eventId) {
        Event event = eventRepository.findById(eventId);
        eventRepository.delete(event);
    }
}
