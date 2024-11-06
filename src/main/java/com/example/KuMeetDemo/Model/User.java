package com.example.KuMeetDemo.Model;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data

@Document("User")

public class User {
    @Id
    private String userId;

    @Indexed
    private String userName;
    private String eMail;
    private String passWord;
    private Date createdAt;

}
