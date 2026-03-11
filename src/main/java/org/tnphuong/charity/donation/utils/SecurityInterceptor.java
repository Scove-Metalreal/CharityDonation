package org.tnphuong.charity.donation.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.tnphuong.charity.donation.entity.User;

@Component
public class SecurityInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        String path = request.getRequestURI();

        // Chặn truy cập Admin
        if (path.startsWith("/admin")) {
            if (user == null || !"ADMIN".equals(user.getRole().getRoleName())) {
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
