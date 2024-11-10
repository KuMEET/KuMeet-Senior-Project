package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.UserEvent;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserEventRepository extends MongoRepository<UserEvent, String> {
}
