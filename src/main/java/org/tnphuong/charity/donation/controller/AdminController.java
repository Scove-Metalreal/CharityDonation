package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @GetMapping("/dashboard")
    public String dashboard() {
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
            // Logic handled in service, but we can catch it here to show error message
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
}
