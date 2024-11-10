package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Location;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LocationRepository extends MongoRepository<Location, String> {
}
