package com.example.KuMeetDemo.Model;

import com.example.KuMeetDemo.Dto.UserReference;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
@Document("Event")
@Data
public class Events {
    @Id
    private UUID id;
    private String eventTitle;
    private String eventDescription;
    private Double latitude;
    private Double longitude;
    private int participantCount;
    private int maxCapacity;
    private Date createdAt;
    private Date eventTime;
    private boolean visibility;
    private List<UserReference> participants = new ArrayList<>();

}
