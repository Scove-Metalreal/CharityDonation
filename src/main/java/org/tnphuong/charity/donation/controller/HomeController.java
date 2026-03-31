package org.tnphuong.charity.donation.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.tnphuong.charity.donation.dao.PaymentMethodRepository;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.PaymentMethod;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

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
    private RoleRepository roleRepository;

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
        model.addAttribute("paymentMethods", paymentMethodRepository.findAll());
        model.addAttribute("currentStatus", status);
        return "index";
    }

    @GetMapping("/campaign/{id}")
    public String campaignDetail(@PathVariable Integer id, Model model, HttpSession session) {
        Optional<Campaign> campaignOpt = campaignService.getCampaignById(id);
        if (campaignOpt.isPresent()) {
            Campaign campaign = campaignOpt.get();
            model.addAttribute("campaign", campaign);

            // Donation statistics
            model.addAttribute("donationCount", donationService.countConfirmedDonationsByCampaignId(id));
            
            // Calculate days remaining
            long daysRemaining = java.time.temporal.ChronoUnit.DAYS.between(java.time.LocalDate.now(), campaign.getEndDate());
            model.addAttribute("daysRemaining", daysRemaining > 0 ? daysRemaining : 0);

            // Top Donors
            model.addAttribute("topDonors10", donationService.getTopDonorsByCampaignId(id, 10));
            model.addAttribute("topDonors20", donationService.getTopDonorsByCampaignId(id, 20));
            
            // Recent Donors
            model.addAttribute("recentDonors10", donationService.getRecentDonorsByCampaignId(id, 10));
            model.addAttribute("recentDonors20", donationService.getRecentDonorsByCampaignId(id, 20));

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
        if (!existing.isPresent()) {
            org.tnphuong.charity.donation.entity.UserFollowing f = new org.tnphuong.charity.donation.entity.UserFollowing();
            f.setUser(userService.getUserById(userId).get());
            f.setCampaign(campaignService.getCampaignById(campaignId).get());
            f.setReceiveEmail(email != null ? email : 0);
            userFollowingRepository.save(f);
        }
        return "redirect:/campaign/" + campaignId;
    }

    @PostMapping("/campaign/unfollow")
    public String unfollowCampaign(@RequestParam Integer campaignId, @RequestParam(required = false) String redirect, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/auth/login";

        userFollowingRepository.findByUserIdAndCampaignId(userId, campaignId).ifPresent(f -> {
            userFollowingRepository.delete(f);
        });
        
        if ("profile".equals(redirect)) {
            return "redirect:/user/profile#following";
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
                         @RequestParam(required = false) String fullName,
                         @RequestParam(required = false) String email,
                         @RequestParam(required = false) String phone,
                         @RequestParam(required = false) String address,
                         @RequestParam(required = false) String message,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {

        Integer userId = (Integer) session.getAttribute("userId");
        User user;

        if (userId == null) {
            // Handle guest user
            if (email == null || email.isBlank()) {
                redirectAttributes.addFlashAttribute("error", "Email is required for guest donations.");
                return "redirect:/campaign/" + campaignId;
            }

            Optional<User> existingUser = userService.getUserByEmail(email);
            if (existingUser.isPresent()) {
                User found = existingUser.get();
                // Check if the email belongs to a registered User (not a Guest)
                if (found.getRole() != null && !"GUEST".equalsIgnoreCase(found.getRole().getRoleName())) {
                    redirectAttributes.addFlashAttribute("error", "Email này đã được đăng ký tài khoản. Vui lòng đăng nhập để quyên góp.");
                    return "redirect:/auth/login";
                }
                // If it is a GUEST, reuse it
                user = found;
            } else {
                // Create a new guest user
                user = new User();
                user.setFullName(fullName != null && !fullName.isBlank() ? fullName : "Nhà hảo tâm ẩn danh");
                user.setEmail(email);
                
                // Generate a dummy phone number if not provided to avoid unique constraint violation
                if (phone == null || phone.isBlank()) {
                    user.setPhoneNumber("GUEST_" + UUID.randomUUID().toString().substring(0, 8));
                } else {
                    user.setPhoneNumber(phone);
                }
                
                user.setAddress(address);
                user.setRole(roleRepository.findByRoleName("GUEST").orElse(null)); // Assign GUEST role
                user.setStatus(1);
                user = userService.saveUser(user); // Save the new user and get persisted entity
            }
        } else {
            // Handle logged-in user
            user = userService.getUserById(userId).orElse(null);
            if (user == null) {
                return "redirect:/auth/login"; // Should not happen if session is valid
            }
        }

        Campaign campaign = campaignService.getCampaignById(campaignId).get();
        PaymentMethod pm = paymentMethodRepository.findById(paymentMethodId).get();

        Donation donation = new Donation();
        donation.setCampaign(campaign);
        donation.setUser(user);
        donation.setAmount(amount);
        donation.setPaymentMethod(pm);
        donation.setIsAnonymous(isAnonymous);

        String transactionCode = "QG" + System.currentTimeMillis() % 1000000;
        // Prepend user message if it exists
        if (message != null && !message.isBlank()) {
            donation.setMessage(message + " (Code: " + transactionCode + ")");
        } else {
            donation.setMessage("Transaction Code: " + transactionCode);
        }

        donation.setStatus(Donation.STATUS_PENDING);

        donation.setCreatedAt(LocalDateTime.now());
        donationService.saveDonation(donation);

        return "redirect:/campaign/" + campaignId + "?success=donated&pending=true&code=" + transactionCode;
    }
}

