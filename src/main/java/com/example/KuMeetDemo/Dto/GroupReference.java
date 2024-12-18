package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;
@Data
public class GroupReference {
    private UUID groupId;
    private Date joinAt;
    private String role;
    private String status;
}
