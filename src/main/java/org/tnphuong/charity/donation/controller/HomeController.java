package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.tnphuong.charity.donation.dao.PaymentMethodRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
public class HomeController {

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private UserService userService;

    @Autowired
    private PaymentMethodRepository paymentMethodRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.UserFollowingRepository userFollowingRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.CompanionRepository companionRepository;

    @GetMapping("/")
    public String home(@RequestParam(required = false, defaultValue = "1") Integer status, 
                       Model model) {
        // Lấy tất cả chiến dịch theo trạng thái để xử lý "Xem thêm" bằng JS
        List<Campaign> allCampaigns = campaignService.getAllCampaigns().stream()
                .filter(c -> c.getStatus().equals(status))
                .sorted((c1, c2) -> c2.getCreatedAt().compareTo(c1.getCreatedAt()))
                .toList();
        
        model.addAttribute("campaigns", allCampaigns);
        model.addAttribute("companions", companionRepository.findAll());
        model.addAttribute("currentStatus", status);
        return "index";
    }

    @GetMapping("/campaign/{id}")
    public String campaignDetail(@PathVariable Integer id, Model model, HttpSession session) {
        Optional<Campaign> campaign = campaignService.getCampaignById(id);
        if (campaign.isPresent()) {
            model.addAttribute("campaign", campaign.get());

            // Top 5 Donors
            model.addAttribute("topDonors", donationService.getTopDonorsByCampaignId(id, 5));
            
            // Recent 10 Donors
            model.addAttribute("recentDonors", donationService.getRecentDonorsByCampaignId(id, 10));

            // Related/Ongoing Campaigns (exclude current)
            Page<Campaign> ongoing = campaignService.getCampaignsByStatus(1, PageRequest.of(0, 4));
            model.addAttribute("ongoingCampaigns", ongoing.getContent());

            // For donation modal
            model.addAttribute("paymentMethods", paymentMethodRepository.findAll());

            // Check following status for logged in user
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                userFollowingRepository.findByUserIdAndCampaignId(userId, id).ifPresent(f -> {
                    model.addAttribute("following", true);
                    model.addAttribute("receiveEmail", f.getReceiveEmail() == 1);
                });
            }

            return "campaign-detail";
        }
        return "redirect:/";
    }

    @PostMapping("/campaign/follow")
    public String followCampaign(@RequestParam Integer campaignId, @RequestParam(required = false) Integer email, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        Optional<org.tnphuong.charity.donation.entity.UserFollowing> existing = userFollowingRepository.findByUserIdAndCampaignId(userId, campaignId);
        if (existing.isPresent()) {
            userFollowingRepository.delete(existing.get());
        } else {
            org.tnphuong.charity.donation.entity.UserFollowing f = new org.tnphuong.charity.donation.entity.UserFollowing();
            f.setUser(userService.getUserById(userId).get());
            f.setCampaign(campaignService.getCampaignById(campaignId).get());
            f.setReceiveEmail(email != null ? email : 0);
            userFollowingRepository.save(f);
        }
        return "redirect:/campaign/" + campaignId;
    }

    @GetMapping("/user/following")
    public String listFollowing(Model model, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";
        
        List<org.tnphuong.charity.donation.entity.UserFollowing> list = userFollowingRepository.findByUserId(userId);
        model.addAttribute("followingList", list);
        return "profile"; // We'll add a tab in profile
    }

    @PostMapping("/campaign/donate")
    public String donate(@RequestParam Integer campaignId,
                         @RequestParam BigDecimal amount,
                         @RequestParam Integer paymentMethodId,
                         @RequestParam(required = false, defaultValue = "0") Integer isAnonymous,
                         HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        Donation donation = new Donation();
        donation.setCampaign(campaignService.getCampaignById(campaignId).get());
        donation.setUser(userService.getUserById(userId).get());
        donation.setAmount(amount);
        donation.setPaymentMethod(paymentMethodRepository.findById(paymentMethodId).get());
        donation.setIsAnonymous(isAnonymous);
        donation.setStatus(0); // Waiting for confirmation
        donation.setCreatedAt(LocalDateTime.now());

        donationService.saveDonation(donation);

        return "redirect:/campaign/" + campaignId + "?success=donated";
    }
}

