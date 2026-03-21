package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.utils.PasswordUtils;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private org.tnphuong.charity.donation.dao.UserRepository userRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.CampaignRepository campaignRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.DonationRepository donationRepository;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("currentPage", "admin-dashboard");
        
        // Real Stats
        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("activeCampaigns", campaignRepository.countByStatus(1));
        model.addAttribute("pendingDonations", donationRepository.countByStatus(0));
        
        java.math.BigDecimal totalAmount = donationRepository.sumTotalDonations();
        model.addAttribute("totalAmount", totalAmount != null ? totalAmount : java.math.BigDecimal.ZERO);

        // Recent Activity for Notifications
        model.addAttribute("recentDonations", donationRepository.findTop5ByOrderByCreatedAtDesc());
        
        return "admin/dashboard";
    }

    // --- USER MANAGEMENT ---
    @GetMapping("/users")
    public String listUsers(@RequestParam(required = false) String keyword, 
                           @RequestParam(defaultValue = "1") int page, 
                           Model model) {
        int pageSize = 10;
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<User> userPage;
        
        String trimmedKeyword = (keyword != null) ? keyword.trim() : "";
        
        if (!trimmedKeyword.isEmpty()) {
            userPage = userService.searchUsers(trimmedKeyword, pageable);
        } else {
            userPage = userService.getAllUsers(pageable);
        }
        
        model.addAttribute("userPage", userPage);
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("keyword", trimmedKeyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        
        return "admin/user-list";
    }

    @GetMapping("/users/add")
    public String showAddUserForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/user-form";
    }

    @PostMapping("/users/save")
    public String saveUser(@ModelAttribute("user") User user, @RequestParam(required = false) String rawPassword) {
        if (rawPassword != null && !rawPassword.isEmpty()) {
            user.setPassword(PasswordUtils.hashPassword(rawPassword));
        } else if (user.getId() == null) {
            // Default password for new users if not provided (should be handled in UI)
            user.setPassword(PasswordUtils.hashPassword("123456"));
        }
        
        userService.saveUser(user);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/toggle-status")
    public String toggleStatus(@RequestParam Integer userId) {
        userService.getUserById(userId).ifPresent(user -> {
            user.setStatus(user.getStatus() == 1 ? 0 : 1);
            userService.saveUser(user);
        });
        return "redirect:/admin/users";
    }

    // --- CAMPAIGN MANAGEMENT ---
    @GetMapping("/campaigns")
    public String listCampaigns(@RequestParam(required = false) Integer status,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String code,
                                @RequestParam(defaultValue = "1") int page,
                                Model model) {
        Pageable pageable = PageRequest.of(page - 1, 10);
        Page<Campaign> campaignPage = campaignService.searchCampaigns(status, phone, code, pageable);
        
        model.addAttribute("campaigns", campaignPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", campaignPage.getTotalPages());
        model.addAttribute("status", status);
        model.addAttribute("phone", phone);
        model.addAttribute("code", code);
        
        return "admin/campaign-list";
    }

    @GetMapping("/campaigns/new")
    public String showCampaignForm(Model model) {
        model.addAttribute("campaign", new Campaign());
        return "admin/campaign-form";
    }

    @GetMapping("/campaigns/edit")
    public String showEditCampaignForm(@RequestParam Integer id, Model model) {
        campaignService.getCampaignById(id).ifPresent(campaign -> model.addAttribute("campaign", campaign));
        return "admin/campaign-form";
    }

    @PostMapping("/campaigns/save")
    public String saveCampaign(@ModelAttribute("campaign") Campaign campaign) {
        campaignService.saveCampaign(campaign);
        return "redirect:/admin/campaigns";
    }

    @PostMapping("/campaigns/delete")
    public String deleteCampaign(@RequestParam Integer id) {
        try {
            campaignService.deleteCampaign(id);
        } catch (Exception e) {
            // Error handling logic
        }
        return "redirect:/admin/campaigns";
    }

    // --- DONATION VERIFICATION ---
    @GetMapping("/donations")
    public String listDonations(Model model) {
        model.addAttribute("donations", donationService.getAllDonations());
        return "admin/donation-list";
    }

    @PostMapping("/donations/confirm")
    public String confirmDonation(@RequestParam Integer donationId) {
        donationService.confirmDonation(donationId);
        return "redirect:/admin/donations";
    }
    
    @PostMapping("/donations/reject")
    public String rejectDonation(@RequestParam Integer donationId) {
        donationService.rejectDonation(donationId);
        return "redirect:/admin/donations";
    }

    @PostMapping("/campaigns/extend")
    public String extendCampaign(@RequestParam Integer id, @RequestParam String newEndDate) {
        campaignService.extendCampaign(id, java.time.LocalDate.parse(newEndDate));
        return "redirect:/admin/campaigns";
    }

    // --- SYSTEM SETTINGS ---
    @GetMapping("/settings")
    public String showSettings() {
        return "admin/settings";
    }
}
