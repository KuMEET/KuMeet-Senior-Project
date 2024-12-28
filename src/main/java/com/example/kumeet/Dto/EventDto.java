package com.example.kumeet.Dto;

import lombok.Data;

import java.util.Date;

@Data

public class EventDto {
    String title;
    String description;
    Double latitude;
    Double longitude;
    int capacity;
    Date time;
    Boolean visibility;
    String categories;

}
