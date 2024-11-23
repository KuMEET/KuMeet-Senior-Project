package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Users;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserRepository extends MongoRepository<Users, UUID> {

    Users findByUserName(String userName);



}
