package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Document("Event")
public class Event {
    @Id
    private UUID id;
    private UUID locationId;

    private String name;
    private String type;
    private String description;
    private int participant;
    private int capacity;
    private Date eventTime;
    private Date createdAt;


    @DocumentReference
    private List<UserEvent> userEvents;
    @DocumentReference(lazy = true)
    private Location location;
    @DocumentReference(lazy = true)
    private Calendar calendar;

}
