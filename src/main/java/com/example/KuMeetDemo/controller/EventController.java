package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Model.Events;
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
    public List<Events> getEvents() {
        return eventService.getAllEvents();
    }
    @PostMapping("/create-event")
    public Events createEvent(@RequestBody EventDto event) {
        return eventService.createEvent(event);
    }
    @DeleteMapping("/delete-event")
    public void deleteEvent(@RequestBody Events event) {
        eventService.deleteEvent(event.getId());
    }
    @PutMapping("/update-event")
    public Events updateEvent(@RequestBody Events event) {
        return eventService.updateEvent(event);
    }
    @GetMapping("/find-event")
    public Events findEvent(@RequestBody Events event) {
        return eventService.getEvent(event.getId());
    }

}
