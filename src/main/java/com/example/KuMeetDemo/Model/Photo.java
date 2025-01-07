package com.example.KuMeetDemo.Model;

import lombok.Data;
import org.bson.types.Binary;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "photos")
public class Photo {
    @Id
    private String id;

    private String title;

    private Binary image;

    public Photo(String title){
        this.title = title;
    }
}
