package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Photo;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

@Repository
@EnableMongoRepositories
public interface PhotoRepository extends MongoRepository<Photo, String> {
}
