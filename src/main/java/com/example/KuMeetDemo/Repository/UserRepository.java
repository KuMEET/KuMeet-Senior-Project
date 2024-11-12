package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    User findById(UUID userId);
}
