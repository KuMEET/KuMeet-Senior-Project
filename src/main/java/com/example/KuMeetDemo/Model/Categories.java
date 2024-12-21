package com.example.KuMeetDemo.Model;

public enum Categories {

    ART_CULTURE("Art & Culture"),
    CAREER_BUSINESS("Career & Business"),
    DANCING("Dancing"),
    GAMES("Games"),
    MUSIC("MUSIC"),
    SCIENCE_EDUCATION("Science & Education"),
    IDENTITY_LANGUAGE("Identity & Language"),
    SOCIAL_ACTIVITIES("Social Activities"),
    SPORTS_FITNESS("Sports & Fitness"),
    TRAVEL_OUTDOOR("Travel & Outdoor");

    public final String name;
    private Categories(String name){
        this.name = name;
    }

}
