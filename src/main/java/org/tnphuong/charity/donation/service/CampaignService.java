package org.tnphuong.charity.donation.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.tnphuong.charity.donation.entity.Campaign;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface CampaignService {
    List<Campaign> getAllCampaigns();
    Page<Campaign> getAllCampaigns(Pageable pageable);
    Optional<Campaign> getCampaignById(Integer id);
    Campaign saveCampaign(Campaign campaign);
    void deleteCampaign(Integer id);
    Optional<Campaign> getCampaignByCode(String code);
    
    Page<Campaign> searchCampaigns(Integer status, String phone, String code, Pageable pageable);
    Page<Campaign> getCampaignsByStatus(Integer status, Pageable pageable);
    
    // Core Logic for Task 6
    void addCurrentMoney(Integer campaignId, BigDecimal amount);
    
    void extendCampaign(Integer campaignId, java.time.LocalDate newEndDate);
}
