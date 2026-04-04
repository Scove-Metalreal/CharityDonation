package org.tnphuong.charity.donation.utils;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.tnphuong.charity.donation.entity.CampaignStatus;
import org.tnphuong.charity.donation.entity.DonationStatus;
import org.tnphuong.charity.donation.entity.UserStatus;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalViewConfig {

    @ModelAttribute("STATUS")
    public Map<String, Object> exposeStatuses() {
        Map<String, Object> statuses = new HashMap<>();
        
        // Campaign Statuses
        statuses.put("CAMPAIGN_NEW", CampaignStatus.NEW.getValue());
        statuses.put("CAMPAIGN_ONGOING", CampaignStatus.IN_PROGRESS.getValue());
        statuses.put("CAMPAIGN_COMPLETED", CampaignStatus.COMPLETED.getValue());
        statuses.put("CAMPAIGN_CLOSED", CampaignStatus.CLOSED.getValue());
        
        // Donation Statuses
        statuses.put("DONATION_PENDING", DonationStatus.PENDING.getValue());
        statuses.put("DONATION_CONFIRMED", DonationStatus.CONFIRMED.getValue());
        statuses.put("DONATION_REJECTED", DonationStatus.REJECTED.getValue());
        
        // User Statuses
        statuses.put("USER_ACTIVE", UserStatus.ACTIVE.getValue());
        statuses.put("USER_LOCKED", UserStatus.LOCKED.getValue());
        
        return statuses;
    }
}
