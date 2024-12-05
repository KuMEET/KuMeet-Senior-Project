package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Events;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;


@Repository
public interface EventRepository extends MongoRepository<Events, UUID> {
}