package com.example.kumeet.Dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data

public class UserGroupDto {
    UUID id;
    UUID groupId;
    UUID userId;

    String role;
    Date joinTime;

}
