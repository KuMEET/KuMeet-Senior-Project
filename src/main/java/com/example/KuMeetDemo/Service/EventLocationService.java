package com.example.KuMeetDemo.Service;

import com.example.KuMeetDemo.Dto.LocationDto;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Groups;
import com.example.KuMeetDemo.Model.Locations;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Repository.EventRepository;
import com.example.KuMeetDemo.Repository.LocationRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Data
@Service
public class EventLocationService {

    @Autowired
    EventRepository eventRepository;
    @Autowired
    LocationRepository locationRepository;
    public ResponseEntity<String> LocationAddToEvent(UUID locationId, UUID eventId){
        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Event with given id %s could not found!", eventId)));
        }

        Locations locations = locationRepository.findById(locationId).orElse(null);
        if (locations == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Location with given id %s could not found!", locationId)));
        }
        Locations eventLocation = events.getLocation();
        if(eventLocation != null){
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("Event with given id %s already has location", eventId));
        }

        events.setLocation(locations);
        eventRepository.save(events);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(String.format("Location with id %s added to event with id %s",locationId, eventId));

    }



    public ResponseEntity<String> deleteLocationFromEvent(UUID locationId, UUID eventId){
        Events events = eventRepository.findById(eventId).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Event with given id %s could not found!", eventId)));
        }

        Locations locations = locationRepository.findById(locationId).orElse(null);
        if (locations == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Location with given id %s could not found!", locationId)));
        }
        Locations eventLocation = events.getLocation();
        if(eventLocation == null){
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("Event with given id %s has not location yet", eventId));
        }
        if(!eventLocation.getLocationId().equals(locationId)){
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("Location with given id does not belong to event with given id", locationId, eventId));
        }
        events.setLocation(null);
        eventRepository.save(events);
        return ResponseEntity.ok(String.format("Location with given id %s is removed from event with given id %s", locationId, eventId));
    }

//    public ResponseEntity<String> updateLocationInEvent(UUID eventId, LocationDto locationDto){
//        Events events = eventRepository.findById(eventId).orElse(null);
//        if (events == null) {
//            return ResponseEntity
//                    .status(HttpStatus.NOT_FOUND)
//                    .body((String.format("Event with given id %s could not found!", eventId)));
//        }
//
//        Locations locations = locationRepository.findById(locationDto.getId()).orElse(null);
//        if (locations == null) {
//            return ResponseEntity
//                    .status(HttpStatus.NOT_FOUND)
//                    .body((String.format("Location with given id %s could not found!", locationDto.getId())));
//        }
//        Locations eventLocation = events.getLocation();
//        if(eventLocation == null){
//            return ResponseEntity
//                    .status(HttpStatus.BAD_REQUEST)
//                    .body(String.format("Event with given id %s has not location yet", eventId));
//        }
//        if(!eventLocation.getLocationId().equals(locationDto.getId())){
//            return ResponseEntity
//                    .status(HttpStatus.BAD_REQUEST)
//                    .body(String.format("Location with given id does not belong to event with given id", locationDto.getId(), eventId));
//        }
//
//        Locations newLocation = new Locations();
//        newLocation.setLocationId();
//
//
//    }
}
