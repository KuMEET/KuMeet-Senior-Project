package com.example.kumeet.Dto;

import lombok.Data;

import java.util.UUID;

@Data

public class LocationDto {
    UUID id;
    int longitude;
    int latitude;
    String address;
}
