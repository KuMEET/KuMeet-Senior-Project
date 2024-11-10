package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.UUID;

@Data

public class GroupDto {
    UUID id;
    String name;
    int capacity;
}
