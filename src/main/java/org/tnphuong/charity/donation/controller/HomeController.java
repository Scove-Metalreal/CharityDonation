package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.tnphuong.charity.donation.service.CampaignService;

@Controller
public class HomeController {

    @Autowired
    private CampaignService campaignService;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("campaigns", campaignService.getAllCampaigns());
        return "index";
    }
}
