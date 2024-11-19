package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Model.Event;
import com.example.KuMeetDemo.Service.EventService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api")
public class EventController {
    @Autowired
    private EventService eventService;

    @GetMapping("/get-events")
    public List<Event> getEvents() {
        return eventService.getAllEvents();
    }
    @PostMapping("/create-event")
    public Event createEvent(@RequestBody EventDto event) {
        return eventService.createEvent(event);
    }
    @DeleteMapping("/delete-event")
    public void deleteEvent(@RequestBody Event event) {
        eventService.deleteEvent(String.valueOf(event.getId()));
    }
    @PutMapping("/update-event")
    public Event updateEvent(@RequestParam String id,@RequestBody EventDto event) {
        return eventService.updateEvent(id, event);
    }
    @GetMapping("/find-event")
    public Event findEvent(@RequestBody Event event) {
        return eventService.getEvent(String.valueOf(event.getId()));
    }

}
