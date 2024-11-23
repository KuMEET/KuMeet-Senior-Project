package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;
@Data
public class EventReference {
    private UUID eventId;
    private Date joinAt;
    private String role;
}
