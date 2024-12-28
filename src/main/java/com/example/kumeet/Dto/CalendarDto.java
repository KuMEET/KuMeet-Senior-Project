package com.example.kumeet.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data

public class CalendarDto {
    UUID id;
    UUID eventId;
    UUID userId;
    Date eventTime;
}
