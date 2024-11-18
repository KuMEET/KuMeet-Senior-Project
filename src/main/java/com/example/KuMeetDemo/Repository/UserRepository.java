package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    User findById(UUID userId);
    User findByName(String userName);

    List<User> findAllByName(String name);


    // adress icin örnekte yapılmıs
//    @Query("{'User.userName':?0 }")
//    List<User> findByName(String name);



}
