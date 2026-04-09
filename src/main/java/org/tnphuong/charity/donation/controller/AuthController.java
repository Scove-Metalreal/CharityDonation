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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.UserStatus;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.service.EmailService;
import org.tnphuong.charity.donation.service.RoleService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;

    @Autowired
    private EmailService emailService;

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

        try {
            roleService.getRoleByName("USER").ifPresent(user::setRole);
            user.setStatus(UserStatus.ACTIVE.getValue());
            
            if ("GOOGLE".equals(user.getAuthProvider())) {
                session.removeAttribute("google_email");
                session.removeAttribute("google_name");
                session.removeAttribute("google_id");
                session.removeAttribute("google_picture");
            }
            
            userService.saveUser(user);
            logger.info("New user registered: {}", user.getEmail());
            return "redirect:/auth/login?success=register&email=" + user.getEmail();
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm(HttpSession session) {
        clearResetSession(session);
        return "login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm(@RequestParam(required = false) String restart, HttpSession session) {
        if ("true".equals(restart)) {
            clearResetSession(session);
        }
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam String email, RedirectAttributes redirectAttributes, HttpSession session) {
        Optional<User> userOpt = userService.getUserByEmail(email.trim());
        
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Email không tồn tại trong hệ thống!");
            return "redirect:/auth/forgot-password";
        }

        User user = userOpt.get();
        session.setAttribute("resetEmail", user.getEmail());
        
        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setResetToken(otp);
        user.setResetTokenExpiry(LocalDateTime.now().plusMinutes(5));
        userService.saveUser(user);

        if ("LOCAL".equals(user.getAuthProvider())) {
            String phone = user.getPhoneNumber();
            String maskedPhone = (phone != null && phone.length() > 4) 
                ? phone.substring(0, 3) + "..." + phone.substring(phone.length() - 3) 
                : "Số điện thoại liên kết";
            
            session.setAttribute("maskedPhone", maskedPhone);
            session.setAttribute("isSMS", true);
            
            logger.info("==========================================");
            logger.info("SMS SIMULATION: Sending OTP to {}", phone);
            logger.info("YOUR OTP CODE IS: {}", otp);
            logger.info("==========================================");
            
            redirectAttributes.addFlashAttribute("message", "Mã xác thực đã được gửi tới số điện thoại " + maskedPhone);
        } else {
            try {
                emailService.sendOTPEmail(user.getEmail(), user.getFullName(), otp);
                redirectAttributes.addFlashAttribute("message", "Mã xác thực đã được gửi tới email " + user.getEmail());
            } catch (Exception e) {
                logger.error("Failed to send OTP email: {}", e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
                return "redirect:/auth/forgot-password";
            }
        }

        return "redirect:/auth/verify-otp";
    }

    @GetMapping("/verify-otp")
    public String showVerifyOTPForm(HttpSession session) {
        if (session.getAttribute("resetEmail") == null) return "redirect:/auth/forgot-password";
        return "forgot-password";
    }

    @PostMapping("/verify-otp")
    public String handleVerifyOTP(@RequestParam String otp, HttpSession session, RedirectAttributes redirectAttributes) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null) return "redirect:/auth/forgot-password";

        Optional<User> userOpt = userService.getUserByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getResetToken() != null && user.getResetToken().equals(otp) 
                && user.getResetTokenExpiry().isAfter(LocalDateTime.now())) {
                session.setAttribute("otpVerified", true);
                return "redirect:/auth/reset-password";
            }
        }

        redirectAttributes.addFlashAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn!");
        return "redirect:/auth/verify-otp";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(HttpSession session) {
        if (session.getAttribute("otpVerified") == null) return "redirect:/auth/forgot-password";
        return "forgot-password";
    }

    @PostMapping("/reset-password")
    public String handleResetPassword(@RequestParam String password, @RequestParam String confirmPassword, 
                                     HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("otpVerified") == null) return "redirect:/auth/forgot-password";
        String email = (String) session.getAttribute("resetEmail");

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp!");
            return "redirect:/auth/reset-password";
        }

        try {
            Optional<User> userOpt = userService.getUserByEmail(email);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setPassword(password);
                user.setResetToken(null);
                user.setResetTokenExpiry(null);
                
                // Auto-upgrade GUEST to USER
                if (user.getRole() != null && "GUEST".equalsIgnoreCase(user.getRole().getRoleName())) {
                    roleService.getRoleByName("USER").ifPresent(user::setRole);
                    logger.info("Auto-upgraded GUEST to USER during password reset: {}", email);
                }
                
                userService.saveUser(user);
                clearResetSession(session);
                
                redirectAttributes.addFlashAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
                return "redirect:/auth/login?email=" + email;
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/auth/reset-password";
        }

        return "redirect:/auth/forgot-password";
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");
        session.removeAttribute("maskedPhone");
        session.removeAttribute("isSMS");
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String email, @RequestParam String password, 
                           HttpSession session, Model model) {
        String cleanEmail = email.trim();
        Optional<User> userOpt = userService.getUserByEmail(cleanEmail);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtils.checkPassword(password, user.getPassword())) {
                if (user.getStatusEnum() == UserStatus.LOCKED) {
                    model.addAttribute("error", "Tài khoản của bạn đã bị khóa!");
                    return "login";
                }

                // Auto-upgrade GUEST to USER upon successful login
                if (user.getRole() != null && "GUEST".equalsIgnoreCase(user.getRole().getRoleName())) {
                    roleService.getRoleByName("USER").ifPresent(user::setRole);
                    logger.info("Auto-upgraded GUEST to USER upon successful login: {}", cleanEmail);
                }

                user.setLastLogin(LocalDateTime.now());
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
