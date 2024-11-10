package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;


@Data
@Document("Group")
public class Group {
    @Id
    private String id;

    private String name;
    private int memberCount;
    private int capacity;
    private Date createdAt;
}
