package com.example.kumeet.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data

public class UserEventDto {
    UUID id;
    UUID eventId;
    UUID userId;

    String role;
    Date registerTime;

}

