package com.example.kumeet.Repository;

import com.example.kumeet.Model.Categories;
import com.example.kumeet.Model.Events;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;


@Repository
@EnableMongoRepositories
public interface EventRepository extends MongoRepository<Events, UUID> {
    List<Events> findByCategories(Categories categories);

}

// mongodb atlasian credentials
// username: aavci19
// password: WmOmSgIjwL1Z7p24
// spring.data.mongodb.uri=mongodb://localhost:27017/todo-manage-api
// mongodump --db your_database_name --out /path/to/backup/