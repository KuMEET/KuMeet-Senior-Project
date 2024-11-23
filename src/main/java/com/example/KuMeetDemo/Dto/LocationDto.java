package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.UUID;

@Data

public class LocationDto {
    UUID id;
    int longitude;
    int latitude;
    String address;
}
