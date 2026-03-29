package org.tnphuong.charity.donation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Role;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.Optional;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional // Tự động rollback dữ liệu sau khi test xong
public class CharityDonationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    private User testAdmin;
    private User testUser;
    private Role adminRole;
    private Role userRole;

    @BeforeEach
    void setUp() {
        // 1. Đảm bảo Role tồn tại trong DB
        adminRole = roleRepository.findByRoleName("ADMIN").orElseGet(() -> {
            Role r = new Role();
            r.setRoleName("ADMIN");
            return roleRepository.save(r);
        });

        userRole = roleRepository.findByRoleName("USER").orElseGet(() -> {
            Role r = new Role();
            r.setRoleName("USER");
            return roleRepository.save(r);
        });

        // 2. Tạo dữ liệu User test
        Optional<User> adminOpt = userService.getUserByEmail("admin_test@charity.com");
        if (adminOpt.isEmpty()) {
            User admin = new User();
            admin.setFullName("Admin Test");
            admin.setEmail("admin_test@charity.com");
            admin.setPassword("123456");
            admin.setStatus(1);
            admin.setRole(adminRole);
            testAdmin = userService.saveUser(admin); 
        } else {
            testAdmin = adminOpt.get();
        }

        Optional<User> userOpt = userService.getUserByEmail("user_test@charity.com");
        if (userOpt.isEmpty()) {
            User user = new User();
            user.setFullName("User Test");
            user.setEmail("user_test@charity.com");
            user.setPassword("123456");
            user.setStatus(1);
            user.setRole(userRole);
            testUser = userService.saveUser(user);
        } else {
            testUser = userOpt.get();
        }
    }

    // --- MODULE AUTH ---

    @Test
    void testRegisterSuccess() throws Exception {
        mockMvc.perform(post("/auth/register")
                .param("fullName", "New User Unit Test")
                .param("email", "unittest_new_user@gmail.com")
                .param("password", "123456")
                .param("phoneNumber", "0123456789"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("/auth/login?success=register*"));
    }

    @Test
    void testLoginSuccessAdmin() throws Exception {
        mockMvc.perform(post("/auth/login")
                .param("email", testAdmin.getEmail())
                .param("password", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/admin/dashboard"));
    }

    @Test
    void testLoginFailWrongPassword() throws Exception {
        mockMvc.perform(post("/auth/login")
                .param("email", testUser.getEmail())
                .param("password", "wrongpass"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"))
                .andExpect(model().attributeExists("error"));
    }

    // --- MODULE ADMIN ---
@Test
void testAdminAccessDeniedForUser() throws Exception {
    MockHttpSession session = new MockHttpSession();
    session.setAttribute("userId", testUser.getId());
    // Load lai user tu DB de dam bao co day du Role object
    User sessionUser = userService.getUserById(testUser.getId()).get();
    session.setAttribute("loggedInUser", sessionUser);

    mockMvc.perform(get("/admin/users")
            .session(session)
            .servletPath("/admin/users")) // Thiet lap servletPath de Interceptor bat duoc
            .andExpect(status().is3xxRedirection())
            .andExpect(redirectedUrl("/auth/login?error=access-denied"));
}

@Test
void testAdminListUsers() throws Exception {
    MockHttpSession session = new MockHttpSession();
    session.setAttribute("userId", testAdmin.getId());
    User sessionAdmin = userService.getUserById(testAdmin.getId()).get();
    session.setAttribute("loggedInUser", sessionAdmin);

    mockMvc.perform(get("/admin/users")
            .session(session)
            .servletPath("/admin/users"))
            .andExpect(status().isOk())
            .andExpect(view().name("admin/user-list"))
            .andExpect(model().attributeExists("users"));
}


    // --- MODULE USER ---

    @Test
    void testUserProfileView() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(get("/user/profile").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("profile"))
                .andExpect(model().attributeExists("user"));
    }

    @Test
    void testUpdateProfile() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(post("/user/update-profile")
                .session(session)
                .param("fullName", "Updated Name")
                .param("email", testUser.getEmail())
                .param("phoneNumber", "0911222333")
                .param("address", "New Address"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/user/profile?message=updated"));
    }
}
