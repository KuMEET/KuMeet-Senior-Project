package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data

public class EventDto {
    String title;
    String description;
    Double latitude;
    Double longitude;
    int capacity;
    Date time;

}
