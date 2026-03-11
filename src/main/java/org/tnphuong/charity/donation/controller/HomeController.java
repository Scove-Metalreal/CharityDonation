package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.service.CampaignService;

import java.util.Optional;

@Controller
public class HomeController {

    @Autowired
    private CampaignService campaignService;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("campaigns", campaignService.getAllCampaigns());
        return "index";
    }

    @GetMapping("/campaign/{id}")
    public String campaignDetail(@PathVariable Integer id, Model model) {
        Optional<Campaign> campaign = campaignService.getCampaignById(id);
        if (campaign.isPresent()) {
            model.addAttribute("campaign", campaign.get());
            return "campaign-detail";
        }
        return "redirect:/";
    }
}
