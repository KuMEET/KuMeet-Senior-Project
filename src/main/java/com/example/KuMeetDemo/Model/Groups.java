package com.example.KuMeetDemo.Model;

import com.example.KuMeetDemo.Dto.UserReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.ReadOnlyProperty;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
@Document("Group")
@Data

public class Groups {
    @Id
    private UUID id;

    private String groupName;
    private int memberCount;
    private int capacity;
    private Date createdAt;
    private boolean visibility;
    private Categories categories;
    private List<UUID> eventsList = new ArrayList<>();
    private List<UserReference> members = new ArrayList<>();


}
