package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.UserService;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @GetMapping("/dashboard")
    public String dashboard() {
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String listUsers(@RequestParam(required = false) String keyword, Model model) {
        List<User> users;
        if (keyword != null && !keyword.isEmpty()) {
            users = userService.searchUsers(keyword);
        } else {
            users = userService.getAllUsers();
        }
        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        return "admin/user-list";
    }

    @PostMapping("/users/toggle-status")
    public String toggleStatus(@RequestParam Integer userId) {
        userService.getUserById(userId).ifPresent(user -> {
            user.setStatus(user.getStatus() == 1 ? 0 : 1);
            userService.saveUser(user);
        });
        return "redirect:/admin/users";
    }
}
