package com.example.KuMeetDemo.event;

import com.example.KuMeetDemo.Model.Users;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class OnRegistrationCompleteEvent extends ApplicationEvent {
    private final Users user;

    public OnRegistrationCompleteEvent(Users user) {
        super(user);
        this.user = user;
    }

    public Users getUser() {
        return user;
    }
}
