package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data

public class EventDto {
    UUID id;
    String name;
    String type;
    String description;
    UUID locationId;
    int capacity;
    Date time;

}
