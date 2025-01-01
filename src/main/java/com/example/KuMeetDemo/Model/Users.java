package com.example.KuMeetDemo.Model;

import com.example.KuMeetDemo.Dto.EventReference;
import com.example.KuMeetDemo.Dto.GroupReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.ArrayList;
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
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String passWord;
    private Date createdAt;
    private boolean enabled;
    private String verificationToken;

    private List<GroupReference> groupReferenceList = new ArrayList<>();
    private List<EventReference> eventReferenceList = new ArrayList<>();
}
