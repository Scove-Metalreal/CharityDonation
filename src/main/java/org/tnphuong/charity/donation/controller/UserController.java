package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/auth/login";
        }
        
        // Load lại data mới nhất từ DB
        User user = userService.getUserById(loggedInUser.getId()).get();
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@ModelAttribute("user") User userUpdate, HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/auth/login";

        User user = userService.getUserById(loggedInUser.getId()).get();
        user.setFullName(userUpdate.getFullName());
        user.setPhoneNumber(userUpdate.getPhoneNumber());
        user.setAddress(userUpdate.getAddress());
        
        userService.saveUser(user);
        session.setAttribute("loggedInUser", user);
        model.addAttribute("message", "Cập nhật thông tin thành công!");
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword, 
                                @RequestParam String newPassword,
                                HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/auth/login";

        User user = userService.getUserById(loggedInUser.getId()).get();
        
        if (!PasswordUtils.checkPassword(oldPassword, user.getPassword())) {
            model.addAttribute("errorPw", "Mật khẩu cũ không chính xác!");
            model.addAttribute("user", user);
            return "profile";
        }

        user.setPassword(PasswordUtils.hashPassword(newPassword));
        userService.saveUser(user);
        
        model.addAttribute("messagePw", "Đổi mật khẩu thành công!");
        model.addAttribute("user", user);
        return "profile";
    }
}
