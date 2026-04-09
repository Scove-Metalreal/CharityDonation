package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.tnphuong.charity.donation.entity.*;
import org.tnphuong.charity.donation.dto.*;
import org.tnphuong.charity.donation.service.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
public class HomeController {

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PaymentMethodService paymentMethodService;

    @Autowired
    private UserFollowingService userFollowingService;

    @Autowired
    private CompanionService companionService;

    @GetMapping("/")
    public String home(@RequestParam(required = false) Integer status, 
                       Model model) {
        // Mặc định là trạng thái IN_PROGRESS nếu không có tham số
        final Integer filterStatus = (status != null) ? status : CampaignStatus.IN_PROGRESS.getValue();
        
        List<CampaignDTO> allCampaigns = campaignService.getAllCampaigns().stream()
                .filter(c -> c.getStatus().equals(filterStatus))
                .sorted((c1, c2) -> c2.getCreatedAt().compareTo(c1.getCreatedAt()))
                .map(campaignService::convertToDTO)
                .toList();
        
        model.addAttribute("campaigns", allCampaigns);
        model.addAttribute("companions", companionService.getAllCompanions());
        model.addAttribute("paymentMethods", paymentMethodService.getAllPaymentMethods());
        model.addAttribute("currentStatus", status);
        return "index";
    }

    @GetMapping("/campaign/{id}")
    public String campaignDetail(@PathVariable Integer id, Model model, HttpSession session) {
        Optional<Campaign> campaignOpt = campaignService.getCampaignById(id);
        if (campaignOpt.isPresent()) {
            Campaign campaign = campaignOpt.get();
            model.addAttribute("campaign", campaignService.convertToDTO(campaign));
            model.addAttribute("donationCount", donationService.countConfirmedDonationsByCampaignId(id));
            
            if (campaign.getEndDate() != null) {
                long daysRemaining = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.now(), campaign.getEndDate());
                model.addAttribute("daysRemaining", daysRemaining > 0 ? daysRemaining : 0);
            } else {
                model.addAttribute("daysRemaining", 0);
            }

            model.addAttribute("topDonors10", donationService.getTopDonorsByCampaignId(id, 10).stream().map(donationService::convertToDTO).toList());
            model.addAttribute("topDonors20", donationService.getTopDonorsByCampaignId(id, 20).stream().map(donationService::convertToDTO).toList());
            model.addAttribute("recentDonors10", donationService.getRecentDonorsByCampaignId(id, 10).stream().map(donationService::convertToDTO).toList());
            model.addAttribute("recentDonors20", donationService.getRecentDonorsByCampaignId(id, 20).stream().map(donationService::convertToDTO).toList());

            List<CampaignDTO> ongoing = campaignService.getCampaignsByStatus(CampaignStatus.IN_PROGRESS.getValue(), PageRequest.of(0, 4))
                    .getContent().stream().map(campaignService::convertToDTO).toList();
            model.addAttribute("ongoingCampaigns", ongoing);
            model.addAttribute("paymentMethods", paymentMethodService.getAllPaymentMethods());

            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                userFollowingService.getFollowing(userId, id).ifPresent(f -> {
                    model.addAttribute("following", true);
                    model.addAttribute("receiveEmail", f.getReceiveEmail() == 1);
                });
            }
            return "campaign-detail";
        }
        return "redirect:/";
    }

    @GetMapping("/companions")
    public String listCompanions(@RequestParam(required = false) Integer id, Model model) {
        try {
            List<Companion> companions = companionService.getAllCompanions();
            model.addAttribute("companions", companions);
            
            if (id != null) {
                companionService.getCompanionById(id).ifPresent(c -> model.addAttribute("selectedCompanion", c));
            } else if (companions != null && !companions.isEmpty()) {
                model.addAttribute("selectedCompanion", companions.get(0));
            }
            return "companion-list";
        } catch (Exception e) {
            logger.error("Error in companions page: {}", e.getMessage());
            return "redirect:/";
        }
    }

    @PostMapping("/campaign/follow")
    public String followCampaign(@RequestParam Integer campaignId, @RequestParam(required = false) Integer email, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        Optional<UserFollowing> existing = userFollowingService.getFollowing(userId, campaignId);
        if (existing.isEmpty()) {
            UserFollowing f = new UserFollowing();
            f.setUser(userService.getUserById(userId).orElseThrow());
            f.setCampaign(campaignService.getCampaignById(campaignId).orElseThrow());
            f.setReceiveEmail(email != null ? email : 0);
            userFollowingService.saveFollowing(f);
            logger.info("User ID {} followed campaign ID {}", userId, campaignId);
        }
        return "redirect:/campaign/" + campaignId;
    }

    @PostMapping("/campaign/unfollow")
    public String unfollowCampaign(@RequestParam Integer campaignId, @RequestParam(required = false) String redirect, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        userFollowingService.getFollowing(userId, campaignId).ifPresent(f -> {
            userFollowingService.deleteFollowing(f);
            logger.info("User ID {} unfollowed campaign ID {}", userId, campaignId);
        });
        
        if ("profile".equals(redirect)) {
            return "redirect:/user/profile#following";
        }
        return "redirect:/campaign/" + campaignId;
    }

    @PostMapping("/campaign/donate")
    public String donate(@RequestParam Integer campaignId,
                         @RequestParam BigDecimal amount,
                         @RequestParam Integer paymentMethodId,
                         @RequestParam(required = false, defaultValue = "0") Integer isAnonymous,
                         @RequestParam(required = false) String fullName,
                         @RequestParam(required = false) String email,
                         @RequestParam(required = false) String phone,
                         @RequestParam(required = false) String address,
                         @RequestParam(required = false) String message,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {

        Integer userId = (Integer) session.getAttribute("userId");
        User user;

        try {
            if (userId == null) {
                user = userService.getOrCreateGuest(email, phone, fullName, address);
            } else {
                user = userService.getUserById(userId).orElseThrow(() -> new RuntimeException("Phiên đăng nhập hết hạn."));
            }

            Campaign campaign = campaignService.getCampaignById(campaignId).orElseThrow();
            PaymentMethod pm = paymentMethodService.getPaymentMethodById(paymentMethodId).orElseThrow();

            Donation donation = new Donation();
            donation.setCampaign(campaign);
            donation.setUser(user);
            donation.setAmount(amount);
            donation.setPaymentMethod(pm);
            donation.setIsAnonymous(isAnonymous);

            String transactionCode = "QG" + (System.currentTimeMillis() % 1000000);
            donation.setMessage((message != null ? message.trim() : "") + " (Code: " + transactionCode + ")");
            donation.setStatus(DonationStatus.PENDING.getValue());
            donation.setCreatedAt(LocalDateTime.now());
            
            donationService.saveDonation(donation);
            logger.info("Donation saved: code={}, user={}", transactionCode, user.getEmail());

            try {
                emailService.sendDonationSubmissionEmail(user.getEmail(), user.getFullName(), campaign.getName(), amount, transactionCode);
            } catch (Exception ex) {
                logger.warn("Email sending failed: {}", ex.getMessage());
            }

            return "redirect:/campaign/" + campaignId + "?success=donated&pending=true&code=" + transactionCode;

        } catch (Exception e) {
            logger.error("Donate error: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/campaign/" + campaignId;
        }
    }
}
