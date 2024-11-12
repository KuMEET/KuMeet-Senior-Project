package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.UUID;

@Data
@Document("UserEvent")
public class UserEvent {

    @Id
    private UUID id;
    private UUID eventId;
    private UUID userId;

    private String role;
    private Date registerTime;
}