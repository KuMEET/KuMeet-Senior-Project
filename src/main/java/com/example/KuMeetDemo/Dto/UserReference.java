package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;
@Data
public class UserReference {
    private UUID userId;
    private Date joinAt;
    private String role;
}
