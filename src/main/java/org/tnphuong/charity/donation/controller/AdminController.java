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

import java.util.List;
import java.util.Optional;

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

    private void addCommonData(Model model) {
        model.addAttribute("recentDonations", donationRepository.findTop5ByOrderByCreatedAtDesc());
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("activePage", "admin-dashboard");
        addCommonData(model);
        
        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("activeCampaigns", campaignRepository.countByStatus(1));
        model.addAttribute("pendingDonations", donationRepository.countByStatus(0));
        
        java.math.BigDecimal totalAmount = donationRepository.sumTotalDonations();
        model.addAttribute("totalAmount", totalAmount != null ? totalAmount : java.math.BigDecimal.ZERO);
        
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String listUsers(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) Integer roleId,
                           @RequestParam(required = false) Integer status,
                           @RequestParam(required = false) String inactive,
                           @RequestParam(defaultValue = "1") int page, 
                           Model model) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model);
        
        int pageSize = 20; 
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        
        java.time.LocalDateTime inactiveSince = null;
        if (inactive != null && !inactive.isEmpty()) {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            switch (inactive) {
                case "1w": inactiveSince = now.minusWeeks(1); break;
                case "1m": inactiveSince = now.minusMonths(1); break;
                case "1q": inactiveSince = now.minusMonths(3); break;
                case "1y": inactiveSince = now.minusYears(1); break;
            }
        }

        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        Page<User> userPage = userService.searchUsers(trimmedKeyword, roleId, status, inactiveSince, pageable);
        
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleId", roleId);
        model.addAttribute("status", status);
        model.addAttribute("inactive", inactive);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("roles", roleRepository.findAll());
        
        return "admin/user-list";
    }

    @GetMapping("/users/detail/{id}")
    public String userDetail(@PathVariable Integer id, Model model) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model);
        userRepository.findById(id).ifPresent(user -> model.addAttribute("user", user));
        return "admin/user-detail";
    }

    @GetMapping("/users/add")
    public String showAddUserForm(Model model) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model);
        model.addAttribute("user", new User());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/user-form";
    }

    @PostMapping("/users/save")
    public String saveUser(@ModelAttribute("user") User user, @RequestParam(required = false) String rawPassword) {
        if (rawPassword != null && !rawPassword.isEmpty()) {
            user.setPassword(PasswordUtils.hashPassword(rawPassword));
        } else if (user.getId() == null) {
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

    @GetMapping("/campaigns")
    public String listCampaigns(@RequestParam(required = false) Integer status,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String code,
                                @RequestParam(defaultValue = "1") int page,
                                Model model) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model);
        
        Pageable pageable = PageRequest.of(page - 1, 20); 
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
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model);
        model.addAttribute("campaign", new Campaign());
        return "admin/campaign-form";
    }

    @GetMapping("/campaigns/edit")
    public String showEditCampaignForm(@RequestParam Integer id, Model model) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model);
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
        } catch (Exception e) {}
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/donations")
    public String listDonations(@RequestParam(required = false) String keyword,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(defaultValue = "1") int page,
                               Model model) {
        model.addAttribute("activePage", "admin-donations");
        addCommonData(model);
        
        Pageable pageable = PageRequest.of(page - 1, 20); 
        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        Page<Donation> donationPage = donationRepository.searchDonations(trimmedKeyword, status, pageable);
        
        model.addAttribute("donations", donationPage.getContent());
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", donationPage.getTotalPages());
        
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

    @GetMapping("/settings")
    public String showSettings(Model model) {
        model.addAttribute("activePage", "admin-settings");
        addCommonData(model);
        return "admin/settings";
    }
}