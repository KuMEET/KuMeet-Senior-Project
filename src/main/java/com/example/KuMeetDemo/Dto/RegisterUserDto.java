package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.UUID;

@Data

public class RegisterUserDto {
    UUID id;
    String userName;
    String password;
    String email;

}
