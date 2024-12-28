package com.example.kumeet.Repository;

import com.example.kumeet.Model.Locations;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
@EnableMongoRepositories
public interface LocationRepository extends MongoRepository<Locations, UUID> {
}
