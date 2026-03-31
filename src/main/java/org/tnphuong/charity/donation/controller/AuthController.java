package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Role;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @GetMapping("/register")
    public String showRegisterForm(Model model, HttpSession session) {
        User user = new User();
        
        // Auto-fill from Google if available
        String googleEmail = (String) session.getAttribute("google_email");
        String googleName = (String) session.getAttribute("google_name");
        
        if (googleEmail != null) {
            user.setEmail(googleEmail);
            user.setFullName(googleName);
            user.setAuthProvider("GOOGLE");
            user.setProviderId((String) session.getAttribute("google_id"));
            user.setAvatarUrl((String) session.getAttribute("google_picture"));
            model.addAttribute("googleMode", true);
        } else {
            user.setAuthProvider("LOCAL");
        }
        
        model.addAttribute("user", user);
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user, HttpSession session, Model model) {
        String email = user.getEmail().trim();
        String phone = user.getPhoneNumber() != null ? user.getPhoneNumber().trim() : "";

        if (userService.getUserByEmail(email).isPresent()) {
            model.addAttribute("error", "Email này đã được sử dụng!");
            return "register";
        }

        // Kiem tra trung so dien thoai
        if (!phone.isEmpty() && userService.getAllUsers().stream().anyMatch(u -> phone.equals(u.getPhoneNumber()))) {
            model.addAttribute("error", "Số điện thoại này đã được sử dụng!");
            return "register";
        }

        Optional<Role> userRole = roleRepository.findByRoleName("USER");
        if (userRole.isPresent()) {
            user.setRole(userRole.get());
        }

        user.setEmail(email);
        user.setPhoneNumber(phone);
        
        // Always hash the provided password, whether it's a local or Google registration
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(PasswordUtils.hashPassword(user.getPassword()));
        }

        if ("GOOGLE".equals(user.getAuthProvider())) {
            // Clear google session data
            session.removeAttribute("google_email");
            session.removeAttribute("google_name");
            session.removeAttribute("google_id");
            session.removeAttribute("google_picture");
        }
        
        user.setStatus(1); 
        userService.saveUser(user);

        return "redirect:/auth/login?success=register&email=" + email;
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String email, @RequestParam String password, 
                           HttpSession session, Model model) {
        String cleanEmail = email.trim();
        
        Optional<User> userOpt = userService.getUserByEmail(cleanEmail);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtils.checkPassword(password, user.getPassword())) {
                if (user.getStatus() != null && user.getStatus() == 0) {
                    model.addAttribute("error", "Tài khoản của bạn đã bị khóa!");
                    return "login";
                }

                // Cập nhật thời gian đăng nhập cuối
                user.setLastLogin(java.time.LocalDateTime.now());
                userService.saveUser(user);
                
                // Luu userId vao session thay vi ca object User de tranh loi Hibernate
                session.setAttribute("userId", user.getId());
                // Van giu loggedInUser neu cac trang JSP dang dung, nhung Interceptor se check theo userId
                session.setAttribute("loggedInUser", user); 
                
                if (user.getRole() != null && "ADMIN".equalsIgnoreCase(user.getRole().getRoleName())) {
                    return "redirect:/admin/dashboard";
                } else {
                    return "redirect:/";
                }
            }
        }
        
        model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
