package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.UUID;

@Data
@Document("Location")

public class Locations {
    private UUID locationId;
    private int latitude;
    private int longitude;
    private String address;
}
