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
import java.util.Optional;

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
        
        String newEmail = userUpdate.getEmail().trim();
        String newPhone = userUpdate.getPhoneNumber() != null ? userUpdate.getPhoneNumber().trim() : "";

        // Check trung Email (khac user hien tai)
        Optional<User> existingEmailUser = userService.getUserByEmail(newEmail);
        if (existingEmailUser.isPresent() && !existingEmailUser.get().getId().equals(userId)) {
            return "redirect:/user/profile?error=duplicate-email";
        }

        // Check trung Phone (khac user hien tai)
        if (!newPhone.isEmpty()) {
            Optional<User> existingPhoneUser = userService.getUserByPhoneNumber(newPhone);
            if (existingPhoneUser.isPresent() && !existingPhoneUser.get().getId().equals(userId)) {
                return "redirect:/user/profile?error=duplicate-phone";
            }
        }

        user.setFullName(userUpdate.getFullName());
        user.setEmail(newEmail);
        user.setPhoneNumber(newPhone);
        user.setAddress(userUpdate.getAddress());
        
        userService.saveUser(user);
        session.setAttribute("loggedInUser", user);
        
        return "redirect:/user/profile?message=updated";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword, 
                                @RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        if (!newPassword.equals(confirmPassword)) {
            return "redirect:/user/profile?errorPw=mismatch";
        }

        User user = userService.getUserById(userId).get();
        
        if (!PasswordUtils.checkPassword(oldPassword, user.getPassword())) {
            return "redirect:/user/profile?errorPw=wrong-old";
        }

        if (PasswordUtils.checkPassword(newPassword, user.getPassword())) {
            return "redirect:/user/profile?errorPw=same-password";
        }

        user.setPassword(PasswordUtils.hashPassword(newPassword));
        userService.saveUser(user);
        
        return "redirect:/user/profile?messagePw=success";
    }
}
