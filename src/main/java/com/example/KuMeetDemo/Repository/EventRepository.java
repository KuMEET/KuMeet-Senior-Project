package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Event;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface EventRepository extends MongoRepository<Event, String> {
}
