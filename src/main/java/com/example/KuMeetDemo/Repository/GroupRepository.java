package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Categories;
import com.example.KuMeetDemo.Model.Events;
import com.example.KuMeetDemo.Model.Groups;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
@EnableMongoRepositories
public interface GroupRepository extends MongoRepository<Groups, UUID> {
    List<Groups> findByCategories(Categories categories);
}
