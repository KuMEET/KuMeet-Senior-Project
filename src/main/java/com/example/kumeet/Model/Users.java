package com.example.kumeet.Model;

import com.example.kumeet.Dto.EventReference;
import com.example.kumeet.Dto.GroupReference;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

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
    private String passWord;
    private Date createdAt;

    private List<GroupReference> groupReferenceList = new ArrayList<>();
    private List<EventReference> eventReferenceList = new ArrayList<>();
}
