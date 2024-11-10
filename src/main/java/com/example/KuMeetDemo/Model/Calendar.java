package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document("Calendar")
public class Calendar {

    @Id
    private String id;
    private String eventId;
    private String userId;
    private Date eventTime;
}
