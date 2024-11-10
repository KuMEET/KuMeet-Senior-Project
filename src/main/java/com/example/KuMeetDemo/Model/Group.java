package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
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
}
