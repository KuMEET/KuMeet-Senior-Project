package com.example.kumeet;

import static com.mongodb.client.model.Filters.eq;

import org.bson.Document;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class QuickStart {
    public static void main( String[] args ) {

        // Replace the placeholder with your MongoDB deployment's connection string
        String uri = "mongodb+srv://aavci19:WmOmSgIjwL1Z7p24@kumeetapplication.nwnho.mongodb.net/";

        try (MongoClient mongoClient = MongoClients.create(uri)) {
            MongoDatabase database = mongoClient.getDatabase("todo-manage-api");
            MongoCollection<Document> collection = database.getCollection("Event");

            Document doc = collection.find(eq("eventTitle", "deneme123")).first();
            if (doc != null) {
                System.out.println(doc.toJson());
            } else {
                System.out.println("No matching documents found.");
            }
        }
    }
}