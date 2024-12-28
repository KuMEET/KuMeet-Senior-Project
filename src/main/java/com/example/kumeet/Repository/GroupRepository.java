package com.example.kumeet.Repository;

import com.example.kumeet.Model.Categories;
import com.example.kumeet.Model.Groups;
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
