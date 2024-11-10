package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.UUID;

@Data
@Document("Location")
public class Location {
    @Id
    private UUID id;
    private int longitude;
    private int latitude;
    private String address;
}
