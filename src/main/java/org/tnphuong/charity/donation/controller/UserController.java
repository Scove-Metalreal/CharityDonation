package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.DonationStatus;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.UserFollowing;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.service.UserFollowingService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private UserFollowingService userFollowingService;

    @Value("${upload.path:uploads/avatars}")
    private String uploadPath;

    @GetMapping("/profile")
    public String showProfile(
            @RequestParam(required = false) Integer donationStatus,
            @RequestParam(required = false) Integer campaignStatus,
            @RequestParam(required = false, defaultValue = "desc") String sort,
            HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }
        
        org.springframework.data.domain.Sort sortObj = "asc".equalsIgnoreCase(sort) 
                ? org.springframework.data.domain.Sort.by("createdAt").ascending() 
                : org.springframework.data.domain.Sort.by("createdAt").descending();

        User user = userService.getUserById(userId).get();
        List<Donation> donations = donationService.getDonationsByUserId(userId, donationStatus, campaignStatus, sortObj);
        List<org.tnphuong.charity.donation.entity.UserFollowing> followingList = userFollowingService.getFollowingByUserId(userId);
        
        model.addAttribute("user", userService.convertToDTO(user));
        model.addAttribute("donations", donations.stream().map(donationService::convertToDTO).toList());
        model.addAttribute("followingList", followingList);
        
        model.addAttribute("donationStatus", donationStatus);
        model.addAttribute("campaignStatus", campaignStatus);
        model.addAttribute("sort", sort);

        return "profile";
    }

    @PostMapping("/upload-avatar")
    public String uploadAvatar(@RequestParam("avatar") MultipartFile file, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        if (!file.isEmpty()) {
            try {
                String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
                Path rootPath = Paths.get("uploads/avatars");
                if (!Files.exists(rootPath)) {
                    Files.createDirectories(rootPath);
                }
                
                Files.copy(file.getInputStream(), rootPath.resolve(fileName));
                
                User user = userService.getUserById(userId).get();
                user.setAvatarUrl("/uploads/avatars/" + fileName);
                userService.saveUser(user);
                session.setAttribute("loggedInUser", user);
                logger.info("User ID {} updated avatar: {}", userId, fileName);
                
            } catch (IOException e) {
                logger.error("Failed to upload avatar for user ID {}: {}", userId, e.getMessage());
                return "redirect:/user/profile?error=upload-failed";
            }
        }
        return "redirect:/user/profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@ModelAttribute("user") User userUpdate, HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        User user = userService.getUserById(userId).get();
        
        String newEmail = userUpdate.getEmail().trim();
        String newPhone = userUpdate.getPhoneNumber() != null ? userUpdate.getPhoneNumber().trim() : "";

        Optional<User> existingEmailUser = userService.getUserByEmail(newEmail);
        if (existingEmailUser.isPresent() && !existingEmailUser.get().getId().equals(userId)) {
            return "redirect:/user/profile?error=duplicate-email";
        }

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
        logger.info("User ID {} updated profile info", userId);
        
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
        logger.info("User ID {} changed password", userId);
        
        return "redirect:/user/profile?messagePw=success";
    }
}
