package com.example.KuMeetDemo.Model;

import com.example.KuMeetDemo.Dto.EventReference;
import com.example.KuMeetDemo.Dto.GroupReference;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
@Document("User")
public class Users {
    @Id
    private UUID id;
    private String userName;
    private String name;
    private String surname;
    private String EMail;
    private String passWord;
    private Date createdAt;

    private List<GroupReference> groupReferenceList;
    private List<EventReference> eventReferenceList;
}
