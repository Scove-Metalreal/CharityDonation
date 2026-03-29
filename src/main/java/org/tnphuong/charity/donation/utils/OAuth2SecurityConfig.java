package org.tnphuong.charity.donation.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.UserService;

import java.io.IOException;
import java.util.Optional;

@Configuration
@EnableWebSecurity
public class OAuth2SecurityConfig {

    @Autowired
    private UserService userService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF for simplicity in this session-based project
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/auth/login")
                .successHandler(oauth2SuccessHandler())
            )
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/auth/login?logout")
            );

        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler oauth2SuccessHandler() {
        return (HttpServletRequest request, HttpServletResponse response, Authentication authentication) -> {
            OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
            String email = oauth2User.getAttribute("email");
            String name = oauth2User.getAttribute("name");
            String providerId = oauth2User.getAttribute("sub"); // Google unique ID
            String picture = oauth2User.getAttribute("picture");

            Optional<User> userOpt = userService.getUserByEmail(email);
            HttpSession session = request.getSession();

            if (userOpt.isPresent()) {
                User user = userOpt.get();
                // Update Google provider info if not set
                if (user.getProviderId() == null) {
                    user.setAuthProvider("GOOGLE");
                    user.setProviderId(providerId);
                    if (user.getAvatarUrl() == null) user.setAvatarUrl(picture);
                    userService.saveUser(user);
                }

                // Sync with existing session logic
                session.setAttribute("userId", user.getId());
                session.setAttribute("loggedInUser", user);
                user.setLastLogin(java.time.LocalDateTime.now());
                userService.saveUser(user);

                if ("ADMIN".equalsIgnoreCase(user.getRole().getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                // Not registered - redirect to register with auto-filled info
                session.setAttribute("google_email", email);
                session.setAttribute("google_name", name);
                session.setAttribute("google_id", providerId);
                session.setAttribute("google_picture", picture);
                
                response.sendRedirect(request.getContextPath() + "/auth/register?google=new");
            }
        };
    }
}
