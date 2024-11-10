package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

@Data
@Document("UserEvent")
public class UserEvent {

    @Id
    private String id;
    private String eventId;
    private String userId;

    private String role;
    private Date registerTime;
}
