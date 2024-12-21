package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Service.GroupEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class GroupEventController {
    @Autowired
    private GroupEventService groupEventService;

    @PostMapping("/add-event-to-group/{eventId}/{groupId}")
    public ResponseEntity<String> EventAddToGroup(@PathVariable String eventId, @PathVariable String groupId){
        return groupEventService.EventAddToGroup(eventId, groupId);
    }

    @DeleteMapping("/remove-event-from-group/{eventId}/{groupId}")
    public ResponseEntity<String> DeleteEventFromGroup(@PathVariable String eventId, @PathVariable String groupId){
        return groupEventService.deleteEventFromGroup(eventId, groupId);
    }

    @GetMapping("/get-past-events-from-group/{groupId}")
    public ResponseEntity<List<Events>> showPastEventsForGroup(@PathVariable String groupId) {
        return groupEventService.showPastEventsForGroup(groupId);
    }

    @GetMapping("/get-upcoming-events-from-group/{groupId}")
    public ResponseEntity<List<Events>> showUpcomingEventsForGroup(@PathVariable String groupId) {
        return groupEventService.showUpcomingEventsForGroup(groupId);
    }

    @GetMapping("/get-events-for-groups/{groupId}")
    public ResponseEntity<List<Events>> getAllEventsForGroup (@PathVariable String groupId) {
        return groupEventService.getAllEventsForGroup(groupId);
    }

}
