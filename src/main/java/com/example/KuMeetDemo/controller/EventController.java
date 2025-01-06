package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.EventDto;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Service.EventService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class EventController {
    @Autowired
    private EventService eventService;

    @GetMapping("/get-events")
    public List<Events> getEvents() {
        return eventService.getAllEvents();
    }
    @PostMapping("/create-event/{username}")
    public ResponseEntity<Events> createEvent(@ModelAttribute EventDto event, @RequestParam("photo") MultipartFile photo, @PathVariable String username) {
        return eventService.createEvent(event, photo, username);
    }
    @DeleteMapping("/delete-event")
    public void deleteEvent(@RequestBody Events event) {
        eventService.deleteEvent(event.getId());
    }
    @PutMapping("/update-event/{eventId}")
    public ResponseEntity<Events> updateEvent(@PathVariable String eventId, @RequestBody EventDto eventDto) {
        return eventService.updateEvent(eventId, eventDto);
    }
    @GetMapping("/find-event")
    public Events findEvent(@RequestBody Events event) {
        return eventService.getEvent(event.getId());
    }

    @GetMapping("/get-all-events-category/{category}")
    public ResponseEntity<List<Events>> FilterEventsBasedOnCategories(@PathVariable String category) {
        return eventService.FilterEventsBasedOnCategories(category);
    }
    @GetMapping("/get-members-for-events/{eventId}")
    public ResponseEntity<List<Users>> ShowMembers(@PathVariable String eventId) {
        return eventService.ShowMembers(eventId);
    }
    @GetMapping("/get-admin-for-events/{eventId}")
    public ResponseEntity<Users> ShowAdmin(@PathVariable String eventId) {
        return eventService.ShowAdmin(eventId);
    }
}
