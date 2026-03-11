package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.Campaign;
import java.util.List;
import java.util.Optional;

public interface CampaignService {
    List<Campaign> getAllCampaigns();
    Optional<Campaign> getCampaignById(Integer id);
    Campaign saveCampaign(Campaign campaign);
    void deleteCampaign(Integer id);
    Optional<Campaign> getCampaignByCode(String code);
}
