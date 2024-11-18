package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Group;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface GroupRepository extends MongoRepository<Group, String> {
    Group findById(UUID id);
    Group findByName(String groupName);

    List<Group> findAllByName(String name);
}
