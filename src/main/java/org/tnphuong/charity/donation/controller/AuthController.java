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
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user, Model model) {
        if (userService.getUserByEmail(user.getEmail()).isPresent()) {
            model.addAttribute("error", "Email đã tồn tại!");
            return "register";
        }

        // Mặc định role là USER khi đăng ký
        Optional<Role> userRole = roleRepository.findByRoleName("USER");
        if (userRole.isPresent()) {
            user.setRole(userRole.get());
        }

        user.setPassword(PasswordUtils.hashPassword(user.getPassword()));
        user.setStatus(1); // Active
        userService.saveUser(user);

        return "redirect:/auth/login?success=register";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String email, @RequestParam String password, 
                           HttpSession session, Model model) {
        Optional<User> userOpt = userService.getUserByEmail(email);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtils.checkPassword(password, user.getPassword())) {
                if (user.getStatus() == 0) {
                    model.addAttribute("error", "Tài khoản của bạn đã bị khóa!");
                    return "login";
                }
                
                session.setAttribute("loggedInUser", user);
                
                if ("ADMIN".equals(user.getRole().getRoleName())) {
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
