package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.Date;
import java.util.UUID;

@Data
@Document("Calendar")
public class Calendar {

    @Id
    private UUID id;
    private UUID eventId;
    private UUID userId;
    private Date eventTime;

    @DocumentReference(lazy=true)
    private User user;
    @DocumentReference(lazy = true)
    private Event event;
}
