package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private DonationService donationService;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }
        
        User user = userService.getUserById(userId).get();
        List<Donation> donations = donationService.getDonationsByUserId(userId);
        
        model.addAttribute("user", user);
        model.addAttribute("donations", donations);
        model.addAttribute("totalDonated", donations.stream().mapToDouble(d -> d.getAmount().doubleValue()).sum());
        
        return "profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@ModelAttribute("user") User userUpdate, HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        User user = userService.getUserById(userId).get();
        user.setFullName(userUpdate.getFullName());
        user.setPhoneNumber(userUpdate.getPhoneNumber());
        user.setAddress(userUpdate.getAddress());
        
        userService.saveUser(user);
        session.setAttribute("loggedInUser", user);
        
        return "redirect:/user/profile?message=updated";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword, 
                                @RequestParam String newPassword,
                                HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        User user = userService.getUserById(userId).get();
        
        if (!PasswordUtils.checkPassword(oldPassword, user.getPassword())) {
            return "redirect:/user/profile?errorPw=wrong-old";
        }

        user.setPassword(PasswordUtils.hashPassword(newPassword));
        userService.saveUser(user);
        
        return "redirect:/user/profile?messagePw=success";
    }
}
