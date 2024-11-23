package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Locations;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LocationRepository extends MongoRepository<Locations, UUID> {
}
