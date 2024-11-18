package com.example.KuMeetDemo.Model;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;


import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Document("User")

public class User {
    @Id
    private UUID id;

    @Indexed
    private String name;
    private String eMail;
    private String passWord;
    private Date createdAt;


    @DocumentReference
    private List<UserGroup> userGroups;
    @DocumentReference
    private List<UserEvent> userEvents;
    @DocumentReference
    private List<Calendar> userCalendars;


}
