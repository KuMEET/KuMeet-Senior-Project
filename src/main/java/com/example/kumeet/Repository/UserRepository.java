package com.example.kumeet.Repository;

import com.example.kumeet.Model.Users;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
@EnableMongoRepositories
public interface UserRepository extends MongoRepository<Users, UUID> {

    Users findByUserName(String userName);
    Optional<Users> findByUserNameOrEMail(String userName, String Email);



}
