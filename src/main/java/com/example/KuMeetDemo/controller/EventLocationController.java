package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Service.EventLocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.UUID;

public class EventLocationController {
    @Autowired
    private EventLocationService eventLocationService;
    @PostMapping("/add-location-event/{locationId}/{eventId}")
    public ResponseEntity<String> locationAddToEventController(@PathVariable UUID locationId, @PathVariable UUID eventId){
        return eventLocationService.LocationAddToEvent(locationId, eventId);
    }
    @DeleteMapping("/remove-location-event/{locationId}/{eventId}")
    public ResponseEntity<String> locationDeleteFromEventController(@PathVariable UUID locationId, @PathVariable UUID eventId){
        return eventLocationService.deleteLocationFromEvent(locationId, eventId);
    }
}
