package com.example.KuMeetDemo.Dto;

import lombok.Data;

import java.util.UUID;

@Data
public class UserDto {
    String userName;
    String name;
    String surname;
    String password;
    String email;
}