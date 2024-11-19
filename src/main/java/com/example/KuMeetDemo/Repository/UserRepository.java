package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    User findByUserName(String userName);

    // adress icin örnekte yapılmıs
//    @Query("{'User.userName':?0 }")
//    List<User> findByName(String name);



}
