package com.example.KuMeetDemo.controller;

import com.example.KuMeetDemo.Dto.UserDto;
import com.example.KuMeetDemo.Model.Users;
import com.example.KuMeetDemo.Service.UserService;
import com.example.KuMeetDemo.event.OnRegistrationCompleteEvent;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private ApplicationEventPublisher eventPublisher;

    @PostMapping("/register")
    public String addUser(@RequestBody UserDto user) {
        ResponseEntity<Users> registeredUser = userService.registerUser(user);
            if (registeredUser.getStatusCode().is2xxSuccessful()) {
                eventPublisher.publishEvent(new OnRegistrationCompleteEvent(registeredUser.getBody()));
                return "redirect:/api/verify-email";
            }
        return "/api/register";
    }

    @GetMapping("/verify-email")
    public String verifyEmail(@RequestParam("token") String token, Model model) {
        String result = userService.validateUser(token);
        if (result.equals("Valid user")) {
            model.addAttribute("message", "Your account has been verified successfully.");
            return "verified";
        } else {
            model.addAttribute("message", "Invalid verification token.");
            return "verify-email";
        }
    }


    // db.User.deleteOne({userName: 'ag12a'})

    @GetMapping("/find/{userName}")
    public Users findUser(@PathVariable String userName) {
        return userService.findByUserName(userName);
    }

    @PutMapping("/update/{userName}")
    public Users updateUser(@PathVariable String userName, @RequestBody UserDto user) {
        return userService.updateUser(userName, user);
    }

    @DeleteMapping("/delete-user/{userId}")
    public Users deleteUser(@PathVariable UUID userId) {
        return userService.deleteUser(userId);
    }

    @GetMapping("/get-all-users")
    public List<Users> getAllUser() {
        return userService.getAllUsers();
    }











}
