package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Role;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.UserStatus;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.Optional;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @GetMapping("/register")
    public String showRegisterForm(@RequestParam(value = "google", required = false) String googleParam, Model model, HttpSession session) {
        User user = new User();
        String googleEmail = (String) session.getAttribute("google_email");
        
        if (googleEmail != null || "new".equals(googleParam)) {
            user.setEmail(googleEmail);
            user.setFullName((String) session.getAttribute("google_name"));
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
    public String registerUser(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session, Model model) {
        if (result.hasErrors()) {
            return "register";
        }

        if (userService.getUserByEmail(user.getEmail()).isPresent()) {
            model.addAttribute("error", "Email này đã được sử dụng!");
            return "register";
        }

        if (user.getPhoneNumber() != null && !user.getPhoneNumber().isEmpty() 
            && userService.getUserByPhoneNumber(user.getPhoneNumber()).isPresent()) {
            model.addAttribute("error", "Số điện thoại này đã được sử dụng!");
            return "register";
        }

        roleRepository.findByRoleName("USER").ifPresent(user::setRole);
        
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(PasswordUtils.hashPassword(user.getPassword()));
        }

        if ("GOOGLE".equals(user.getAuthProvider())) {
            session.removeAttribute("google_email");
            session.removeAttribute("google_name");
            session.removeAttribute("google_id");
            session.removeAttribute("google_picture");
        }
        
        user.setStatus(UserStatus.ACTIVE.getValue()); 
        userService.saveUser(user);

        logger.info("New user registered: {}", user.getEmail());
        return "redirect:/auth/login?success=register&email=" + user.getEmail();
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
                if (user.getStatus() != null && user.getStatus() == UserStatus.LOCKED.getValue()) {
                    model.addAttribute("error", "Tài khoản của bạn đã bị khóa!");
                    return "login";
                }

                user.setLastLogin(java.time.LocalDateTime.now());
                userService.saveUser(user);
                
                session.setAttribute("userId", user.getId());
                session.setAttribute("loggedInUser", user); 
                
                logger.info("User logged in: {}", cleanEmail);
                return (user.getRole() != null && "ADMIN".equalsIgnoreCase(user.getRole().getRoleName())) 
                        ? "redirect:/admin/dashboard" : "redirect:/";
            }
        }
        
        logger.warn("Failed login attempt for email: {}", cleanEmail);
        model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
