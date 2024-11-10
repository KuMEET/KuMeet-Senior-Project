package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document("Event")
public class Event {
    @Id
    private String id;
    private String locationId;

    private String name;
    private String type;
    private String description;
    private int participant;
    private int capacity;
    private Date eventTime;
    private Date createdAt;
}
