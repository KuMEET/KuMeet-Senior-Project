package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.Date;
import java.util.List;
import java.util.UUID;


@Data
@Document("Group")
public class Group {
    @Id
    private UUID id;

    private String name;
    private int memberCount;
    private int capacity;
    private Date createdAt;


    @DocumentReference(lazy = true)
    private List<UserGroup> userGroups;


}
