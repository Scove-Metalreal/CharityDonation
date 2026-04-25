package org.tnphuong.charity.donation.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.UserStatus;
import org.tnphuong.charity.donation.service.UserService;

import java.util.Optional;

@Component
public class SecurityInterceptor implements HandlerInterceptor {

    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        String path = request.getRequestURI().substring(request.getContextPath().length());

        User user = null;
        if (userId != null) {
            Optional<User> userOpt = userService.getUserById(userId);
            if (userOpt.isPresent()) {
                user = userOpt.get();
                
                // KIỂM TRA TÀI KHOẢN CÓ BỊ KHÓA KHÔNG (Real-time check)
                if (user.getStatus() == UserStatus.LOCKED.getValue()) {
                    session.invalidate(); // Hủy toàn bộ session
                    response.sendRedirect(request.getContextPath() + "/auth/login?error=account-locked");
                    return false;
                }
                
                session.setAttribute("loggedInUser", user);
            } else {
                // Nếu User ID có trong session nhưng không tìm thấy trong DB (có thể bị xóa)
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return false;
            }
        }

        // Chặn truy cập Admin
        if (path.startsWith("/admin")) {
            if (user == null || user.getRole() == null || !"ADMIN".equalsIgnoreCase(user.getRole().getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/auth/login?error=access-denied");
                return false;
            }
        }

        // Chặn truy cập User Profile
        if (path.startsWith("/user")) {
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return false;
            }
        }

        return true;
    }
}
