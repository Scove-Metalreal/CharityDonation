package org.tnphuong.charity.donation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.CampaignRepository;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.*;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

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
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private CampaignRepository campaignRepository;

    private User testAdmin;
    private User testUser;
    private Campaign testCampaign;

    @BeforeEach
    void setUp() {
        // 1. Đảm bảo Role tồn tại
        Role adminRole = roleRepository.findByRoleName("ADMIN").orElseGet(() -> {
            Role r = new Role(); r.setRoleName("ADMIN"); return roleRepository.save(r);
        });
        Role userRole = roleRepository.findByRoleName("USER").orElseGet(() -> {
            Role r = new Role(); r.setRoleName("USER"); return roleRepository.save(r);
        });

        // 2. Tạo dữ liệu User test (Bổ sung phoneNumber để tránh ConstraintViolationException)
        testAdmin = userService.getUserByEmail("admin_test@charity.com").orElseGet(() -> {
            User u = new User();
            u.setFullName("Admin Test"); u.setEmail("admin_test@charity.com");
            u.setPassword("123456"); u.setPhoneNumber("0988111222"); u.setStatus(1); u.setRole(adminRole);
            return userService.saveUser(u);
        });

        testUser = userService.getUserByEmail("user_test@charity.com").orElseGet(() -> {
            User u = new User();
            u.setFullName("User Test"); u.setEmail("user_test@charity.com");
            u.setPassword("123456"); u.setPhoneNumber("0988333444"); u.setStatus(1); u.setRole(userRole);
            return userService.saveUser(u);
        });

        // 3. Tạo Chiến dịch test
        testCampaign = campaignRepository.findByCode("TEST001").orElseGet(() -> {
            Campaign c = new Campaign();
            c.setCode("TEST001"); c.setName("Chiến dịch Test");
            c.setTargetMoney(new BigDecimal("10000000"));
            c.setStartDate(LocalDate.now()); c.setEndDate(LocalDate.now().plusMonths(1));
            c.setStatus(CampaignStatus.IN_PROGRESS.getValue());
            return campaignRepository.save(c);
        });
    }

    // --- MODULE AUTH & PROFILE ---

    @Test
    void testRegisterSuccess() throws Exception {
        mockMvc.perform(post("/auth/register")
                .param("fullName", "New User Unit Test")
                .param("email", "unittest_new_user@gmail.com")
                .param("password", "123456")
                .param("phoneNumber", "0987654321"))
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
    void testUpdateProfileSuccess() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(post("/user/update-profile")
                .session(session)
                .param("fullName", "Updated Name")
                .param("email", testUser.getEmail())
                .param("phoneNumber", "0911222333"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/user/profile?message=updated"));
    }

    // --- MODULE ADMIN & CAMPAIGN ---

    @Test
    void testAdminAccessDeniedForUser() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(get("/admin/users")
                .session(session)
                .servletPath("/admin/users"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?error=access-denied"));
    }

    @Test
    void testAdminCreateCampaignSuccess() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testAdmin.getId());
        session.setAttribute("loggedInUser", testAdmin);

        mockMvc.perform(post("/admin/campaigns/save")
                .session(session)
                .param("code", "NEWCPG")
                .param("name", "New Campaign Name")
                .param("startDate", LocalDate.now().toString())
                .param("endDate", LocalDate.now().plusDays(10).toString())
                .param("targetMoney", "5000000")
                .param("status", "0"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Lưu chiến dịch thành công!"));
    }

    // --- MODULE DONATION ---

    @Test
    void testUserDonateSuccess() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(post("/campaign/donate")
                .session(session)
                .param("campaignId", testCampaign.getId().toString())
                .param("amount", "50000")
                .param("paymentMethodId", "1")) 
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("/campaign/" + testCampaign.getId() + "?success=donated*"));
    }

    @Test
    void testDonateFailTooSmallAmount() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testUser.getId());
        session.setAttribute("loggedInUser", testUser);

        mockMvc.perform(post("/campaign/donate")
                .session(session)
                .param("campaignId", testCampaign.getId().toString())
                .param("amount", "500") // < 1000
                .param("paymentMethodId", "1"))
                .andExpect(status().is3xxRedirection())
                .andExpect(flash().attributeExists("error"));
    }

    @Test
    void testAdminDashboardStatsPresent() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", testAdmin.getId());
        session.setAttribute("loggedInUser", testAdmin);

        mockMvc.perform(get("/admin/dashboard").session(session).servletPath("/admin/dashboard"))
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("totalAmount", "totalUsers", "activeCampaigns", "pendingDonations"));
    }

    @Test
    void testHomePageFilteringByStatus() throws Exception {
        mockMvc.perform(get("/").param("status", "2")) // 2 = COMPLETED
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("campaigns", "currentStatus"));
    }

    @Test
    void testViewHistorySecurityForGuest() throws Exception {
        mockMvc.perform(get("/user/profile")) // Không có session
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login"));
    }
}
