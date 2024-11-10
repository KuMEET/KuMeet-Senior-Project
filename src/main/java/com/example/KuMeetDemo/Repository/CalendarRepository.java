package com.example.KuMeetDemo.Repository;

import com.example.KuMeetDemo.Model.Calendar;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CalendarRepository extends MongoRepository<Calendar, String> {
}
