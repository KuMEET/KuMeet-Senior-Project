package com.example.kumeet.Service;

import com.example.kumeet.Model.Events;
import com.example.kumeet.Model.Groups;
import com.example.kumeet.Repository.EventRepository;
import com.example.kumeet.Repository.GroupRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;


import java.util.*;
@Data
@Service
public class GroupEventService {
    @Autowired
    GroupRepository groupRepository;
    @Autowired
    EventRepository eventRepository;

    public ResponseEntity<String> EventAddToGroup(String eventId, String groupId) {
        UUID eventID = UUID.fromString(eventId);
        Events events = eventRepository.findById(eventID).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Event with given eventId %s could not found!", eventId)));
        }

        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body((String.format("Group with given groupId %s could not found!", groupId)));
        }

        List<UUID> groupsEventList = groups.getEventsList();
        for (UUID eventListId: groupsEventList){
            if (eventListId.equals(eventID)){
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .body(String.format("Event with given eventId %s already exists!", eventId));
            }
        }
        events.setGroupID(groupID);
        groupsEventList.add(eventID);
        groups.setEventsList(groupsEventList);
        groupRepository.save(groups);
        eventRepository.save(events);
        String message = String.format("Event with given eventId %s added to group with given groupId %s", eventId, groupId);
        return ResponseEntity.ok(message);

    }
    public ResponseEntity<String> deleteEventFromGroup(String eventId, String groupId) {
        UUID eventID = UUID.fromString(eventId);
        Events events = eventRepository.findById(eventID).orElse(null);
        if (events == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Event with given eventId %s could not be found!", eventId));
        }

        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(String.format("Group with given groupId %s could not be found!", groupId));
        }

        List<UUID> groupsEventList = groups.getEventsList();
        if (!groupsEventList.contains(eventID)) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(String.format("Event with given eventId %s is not associated with groupId %s!", eventId, groupId));
        }

        groupsEventList.remove(eventID);
        groups.setEventsList(groupsEventList);
        groupRepository.save(groups);

        events.setGroupID(null);
        eventRepository.save(events);

        String message = String.format("Event with given eventId %s has been removed from group with given groupId %s", eventId, groupId);
        return ResponseEntity.ok(message);
    }

    public ResponseEntity<List<Events>> showPastEventsForGroup (String groupId) {
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        List<UUID> eventList = groups.getEventsList();
        if (eventList.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        List<Events> pastEvents = new ArrayList<>();
        eventList.forEach(
                event -> {
                    Events events = eventRepository.findById(event).orElse(null);
                    if (events.getEventTime().before(new Date())) {
                        pastEvents.add(events);
                    }
                }
        );
        return ResponseEntity.ok(pastEvents);

    }

    public ResponseEntity<List<Events>> showUpcomingEventsForGroup (String groupId) {
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }
        List<UUID> eventList = groups.getEventsList();
        if (eventList.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }
        List<Events> upcomingEvents = new ArrayList<>();
        eventList.forEach(
                event -> {
                    Events events = eventRepository.findById(event).orElse(null);
                    if (events.getEventTime().after(new Date())) {
                        upcomingEvents.add(events);
                    }
                }
        );
        return ResponseEntity.ok(upcomingEvents);
    }

    public ResponseEntity<List<Events>> getAllEventsForGroup (String groupId) {
        UUID groupID = UUID.fromString(groupId);
        Groups groups = groupRepository.findById(groupID).orElse(null);
        if (groups == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }
        List<UUID> eventList = groups.getEventsList();
        List<Events> eventsList = new ArrayList<>();
        eventList.forEach(
                element -> {
                    Events events = eventRepository.findById(element).orElse(null);
                    if (events != null) {
                        eventsList.add(events);
                    }
                }
        );
        return ResponseEntity.ok(eventsList);

    }










    // user kendisi direkt olarak event create edebilir
    // user kendisi group create edebilir
    // user group create ettikten sonra group'un icerisinde de event create edebilir
    // eventleri listelemek ise grouplardan ve visibility durumlarından bagımsız olarak gösterilmeli
    // grouplar eventlerini gösterebilmeli (gecmis ve gelecek olacak sekilde)
    // grouplardan eventlar silinebilir
    // group silindigi zaman ise eventlar da eğer bağlı ise otomatik olarak o eventların da silinmesi gerekiyor (delete group kısmında bunu check etmeliyiz)
    // groupun icerisinde eventa katılanlar ve düzenleyenler de gözükmeli
    // group tarafından oluşturulan eventlar icin frontend tarafında grouptan category bilgisi cekilip event categorisi otomatik olarak setlenebilir.
















}
