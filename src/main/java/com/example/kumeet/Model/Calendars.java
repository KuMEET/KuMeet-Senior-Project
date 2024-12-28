package com.example.kumeet.Model;

import com.example.kumeet.Dto.CalendarReference;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.List;
import java.util.UUID;
@Document("Calendar")

public class Calendars {
    @Id
    private UUID id;
    private UUID eventId;
    private UUID userId;
    private Date eventTime;
    private List<CalendarReference> events;
}
