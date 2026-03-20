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

    @GetMapping("/")
    public String home(@RequestParam(required = false, defaultValue = "1") Integer status, 
                       @RequestParam(defaultValue = "1") int page,
                       Model model) {
        Page<Campaign> campaignPage = campaignService.getCampaignsByStatus(status, PageRequest.of(page - 1, 9));
        model.addAttribute("campaigns", campaignPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", campaignPage.getTotalPages());
        model.addAttribute("currentStatus", status);
        return "index";
    }

    @GetMapping("/campaign/{id}")
    public String campaignDetail(@PathVariable Integer id, Model model) {
        Optional<Campaign> campaign = campaignService.getCampaignById(id);
        if (campaign.isPresent()) {
            model.addAttribute("campaign", campaign.get());

            // Get confirmed donors
            List<Donation> confirmedDonations = donationService.getConfirmedDonationsByCampaignId(id);
            model.addAttribute("donors", confirmedDonations);

            // For donation modal
            model.addAttribute("paymentMethods", paymentMethodRepository.findAll());

            return "campaign-detail";
        }
        return "redirect:/";
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

